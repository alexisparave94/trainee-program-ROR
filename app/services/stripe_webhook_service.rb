# frozen_string_literal: true

# Service object for stripe webhook
class StripeWebhookService < ApplicationService
  def initialize(request, webhook_key)
    @request = request
    @webhook_key = webhook_key.to_s
    super()
  end

  def call
    webhook
  end

  private

  def webhook
    validate_webhook
    @event_object = @event.data.object
    set_user

    # Handle events
    handle_event
  end

  def validate_webhook
    payload = @request.body.read
    sig_header = @request.env['HTTP_STRIPE_SIGNATURE']
    @event = nil

    begin
      @event = Stripe::Webhook.construct_event(
        payload, sig_header, @webhook_key
      )
    rescue JSON::ParserError => e
      p e
      400
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts 'Signature error'
      p e
      400
    end
  end

  def set_user
    @user =  User.find_by(stripe_customer_id: @event_object.customer)
  end

  def set_order
    @order = @user.orders.find_by(status: 'pending')
  end
end
