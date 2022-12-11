# frozen_string_literal: true

module Operations
  module Customer
    module ShoppingCart
      # Class to manage operation of show a product
      class Checkout < Trailblazer::Operation
        step :check_stock
        step :identify_stripe_customer
        step :create_session

        def check_stock(_ctx, order:, **)
          lines_exceed_stock(order).compact.empty?
        end

        def identify_stripe_customer(_ctx, current_user:, **)
          return current_user if current_user.stripe_customer_id

          customer = Stripe::Customer.create(email: current_user.email)
          current_user.update(stripe_customer_id: customer.id)
        end

        def create_session(ctx, current_user:, success_url:, cancel_url:, **)
          ctx[:session] = Stripe::Checkout::Session.create(
            {
              customer: current_user.stripe_customer_id,
              payment_method_types: ['card'],
              line_items: stripe_format_line_items(ctx[:order]),
              mode: 'payment',
              success_url:,
              cancel_url:
            }
          )
        end

        private

        def stripe_format_line_items(order)
          order.order_lines.includes(:product).map do |line|
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

        def lines_exceed_stock(order)
          order.order_lines.map do |order_line|
            stock = Product.find(order_line.product_id).stock
            current_quantity = order_line.quantity
            stock < current_quantity ? order_line.product : nil
          end
        end
      end
    end
  end
end
