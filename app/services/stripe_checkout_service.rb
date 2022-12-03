# frozen_string_literal: true

# Service object to empty a shopping cart
# for a no logged in user
class StripeCheckoutService < ApplicationService
  def initialize(order, success_url, cancel_url)
    @order = order
    @success_url = success_url
    @cancel_url = cancel_url
    super()
  end

  def call
    session
  end

  private

  def session
    Stripe::Checkout::Session.create(
      {
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
          unit_amount: 2000,
          currency: 'usd'
        },
        quantity: line.quantity
      }
    end
  end
end
