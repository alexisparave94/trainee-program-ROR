# frozen_string_literal: true

# Service object for stripe checkout service completed webhook
class CheckoutSessionCompletedService < StripeWebhookService
  private

  def handle_event
    case @event.type
    when 'checkout.session.completed'
      get_session
      set_order
      @order.update(status: 'completed', total: @order.calculate_total)
      PurchaseDetailsMailer.purchase_details(@user.email, @order).deliver
      line_items.data.each do |line_item|
        reduce_stock(line_item)
      end
      Customer::LastUserNotifier.call(@order)
      @user.transactions.create(status: 'success', description: 'checkout completed', amount: @event_object.amount_total)
      200
    end
  end

  def get_session
    @session = Stripe::Checkout::Session.retrieve({ id: @event_object.id, expand: ['line_items', 'customer_details'] })
  end

  def line_items
    @session.line_items
  end

  def reduce_stock(line_item)
    product = Product.find_by(stripe_product_id: line_item.price.product)
    product.stock -= line_item.quantity
    product.save
  end
end
