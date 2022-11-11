# frozen_string_literal: true

module Customer
  # Service object to checkout order lines of a shopping cart
  # for a logged in customer user
  class CheckoutHandler < ApplicationService
    def initialize(order_id)
      @order_id = order_id
      super()
    end

    def call
      set_order
      lines_exceed_stock.compact
    end

    private

    def set_order
      @order = Order.find(@order_id)
    end

    # Method to look for products that exceed the stock of an order
    def lines_exceed_stock
      @order.order_lines.map do |order_line|
        stock = Product.find(order_line.product_id).stock
        current_quantity = order_line.quantity
        stock < current_quantity ? order_line.product : nil
      end
    end
  end
end
