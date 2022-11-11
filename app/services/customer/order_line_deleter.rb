# frozen_string_literal: true

module Customer
  # Service object to delete a product of a shopping cart
  # for a logged in customer user
  class OrderLineDeleter < ApplicationService
    def initialize(order_line)
      @order_line = order_line
      super()
    end

    def call
      delete_order
    end

    def delete_order
      @order_line.destroy
    end
  end
end
