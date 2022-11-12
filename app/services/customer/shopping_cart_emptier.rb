# frozen_string_literal: true

module Customer
  # Service object to empty a shopping cart
  # for a logged in customer user
  class ShoppingCartEmptier < ApplicationService
    def initialize(order_id)
      @order_id = order_id
      super()
    end

    def call
      empty_cart
    end

    def empty_cart
      OrderLine.destroy_by(order_id: @order_id)
    end
  end
end
