# frozen_string_literal: true

# Service object to empty a shopping cart
# for a no logged in user
class StripeCheckoutService < ApplicationService
  def initialize(user, order, success_url, cancel_url)
    @user = user
    @order = order
    @success_url = success_url
    @cancel_url = cancel_url
    super()
  end

  private
  
  def session
    Stripe::Checkout::Session.create(
      {
        customer: @user.stripe_customer_id,
        payment_method_types: ['card'],
        line_items: stripe_format_line_items,
        mode: 'payment',
        success_url: @success_url,
        cancel_url: @cancel_url
      }
    )
  end

  def stripe_format_line_items
    @order.order_lines.includes(:product).map do |line|
      {
        price_data: {
          product: line.product.stripe_product_id,
          unit_amount: line.price.to_i,
          currency: 'usd'
        },
        quantity: line.quantity
      }
    end
  end

  def lines_exceed_stock
    @order.order_lines.map do |order_line|
      stock = Product.find(order_line.product_id).stock
      current_quantity = order_line.quantity
      stock < current_quantity ? order_line.product : nil
    end
  end
end
