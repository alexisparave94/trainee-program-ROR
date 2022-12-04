# frozen_string_literal: true

# Service object for stripe webhook
class StripeWebhookService < ApplicationService
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

    # Handle the event
    # pp '=============Event type================'
    # pp @event
    case @event.type
    when 'checkout.session.completed'
      # Review of stack before
      get_session
      set_email
      set_order
      @order.update(status: 'completed', total: @order.calculate_total)
      PurchaseDetailsMailer.purchase_details(@email, @order).deliver
      line_items.data.each do |line_item|
        reduce_stock(line_item)
      end
      # when 'failed'
      # Notify failed
    end
  end

  def validate_webhook
    payload = @request.body.read
    sig_header = @request.env['HTTP_STRIPE_SIGNATURE']
    @event = nil

    begin
      @event = Stripe::Webhook.construct_event(
        payload, sig_header, 'whsec_gi22RnIGewTHEHn76jexsjYHf9VIdGyA'
      )
    rescue JSON::ParserError => e
      p e
      status 400
      # return
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts 'Signature error'
      p e
      # return
    end
  end

  def get_session
    session_object = @event.data.object
    @session = Stripe::Checkout::Session.retrieve({ id: session_object.id, expand: ['line_items', 'customer_details'] })
  end
  
  def line_items
    @session.line_items
  end

  def set_email
    @email = @session.customer_details.email
  end

  def set_order
    user = User.find_by(email: set_email)
    @order = user.orders.find_by(status: 'pending')
  end

  def reduce_stock(line_item)
    product = Product.find_by(stripe_product_id: line_item.price.product)
    product.stock -= line_item.quantity
    product.save
  end
end
