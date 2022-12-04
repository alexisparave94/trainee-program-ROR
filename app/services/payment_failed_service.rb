# frozen_string_literal: true

# Service object for stripe webhook
class PaymentFailedService < ApplicationService
  def initialize(request)
    @request = request
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
    case @event.type
    when 'payment_intent.payment_failed'
      err = @event_object.last_payment_error
      # PurchaseDetailsMailer.incompleted_purchase(@user.email, err.message).deliver
      @user.transactions.create(status: 'failed', description: err.message, amount: @event_object.amount)
      return 400
    end
  end

  def validate_webhook
    payload = @request.body.read
    sig_header = @request.env['HTTP_STRIPE_SIGNATURE']
    @event = nil

    begin
      @event = Stripe::Webhook.construct_event(
        payload, sig_header, 'whsec_l3F5kg4unr74MrBaATriQMuXaQrJkFop'
      )
    rescue JSON::ParserError => e
      p e
      return 400
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts 'Signature error'
      p e
      return 400
    end
  end

  def set_user
    @user =  User.find_by(stripe_customer_id: @event_object.customer)
  end

  def set_order
    @order = @user.orders.find_by(status: 'pending')
  end
end
