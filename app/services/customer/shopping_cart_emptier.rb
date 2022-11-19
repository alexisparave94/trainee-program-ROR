# frozen_string_literal: true

module Customer
  # Service object to empty a shopping cart
  # for a logged in customer user
  class ShoppingCartEmptier < ApplicationService
    def initialize(order_id)
      @order_id = order_id
      @order = Order.find(order_id)
      super()
    end

    def call
      raise(StandardError, 'The purchase has been completed') unless @order.pending?

      empty_cart
    end

    def empty_cart
      OrderLine.destroy_by(order_id: @order_id)
    end
  end
end
