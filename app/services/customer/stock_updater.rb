# frozen_string_literal: true

module Customer
  class StockUpdater < ApplicationService
    def initialize(order)
      @order = order
      super()
    end

    def call
      update_stock
    end

    private

    attr_reader :order

    def update_stock
      order.order_lines.each do |order_line|
        product = Product.find(order_line.product_id)
        product.stock -= order_line.quantity
        product.save
      end
    end
  end
end
