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
    @event_object = @event.data.object
    set_user

    # Handle events
    case @event.type
    when 'checkout.session.completed'
      get_session
      set_order
      @order.update(status: 'completed', total: @order.calculate_total)
      PurchaseDetailsMailer.purchase_details(@user.email, @order).deliver
      line_items.data.each do |line_item|
        reduce_stock(line_item)
      end
    when 'payment_intent.payment_failed'
      err = @event_object.last_payment_error
      message = err.message
      PurchaseDetailsMailer.incompleted_purchase(@user.email, err.message).deliver
      # when 'charge.succeeded'
      #   pp '===================='
      #   pp 'Suceeeeeeddddddddddddd'
      #   pp @event
      #   pp charge = @event.data.object
      #   pp user =  User.find_by(email: charge.billing_details.email)
      #   order = user.orders.find_by(status: 'pending')
      #   pp order.order_lines
      #   verify_stock = order.order_lines.map do |order_line|
      #     stock = Product.find(order_line.product_id).stock
      #     current_quantity = order_line.quantity
      #     stock < current_quantity ? order_line.product : nil
      #   end
      #   begin
      #     pp arr = verify_stock.compact
      #     pp arr.empty?
      #     raise(StandardError,'Not enough stock') if arr.empty?
      #   rescue StandardError => e
      #     return 400
      #   end
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
      return status 400
    rescue Stripe::SignatureVerificationError => e
      # Invalid signature
      puts 'Signature error'
      p e
      return status 400
    end
  end

  def get_session
    @session = Stripe::Checkout::Session.retrieve({ id: @event_object.id, expand: ['line_items', 'customer_details'] })
  end
  
  def line_items
    @session.line_items
  end

  def set_user
    @user =  User.find_by(stripe_customer_id: @event_object.customer)
  end

  def set_order
    @order = @user.orders.find_by(status: 'pending')
  end

  def reduce_stock(line_item)
    product = Product.find_by(stripe_product_id: line_item.price.product)
    product.stock -= line_item.quantity
    product.save
  end
end
