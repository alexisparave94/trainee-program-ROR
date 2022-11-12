# frozen_string_literal: true

module Customer
  # Service object to delete a product of a shopping cart
  # for a logged in customer user
  class OrderDeleter < ApplicationService
    def initialize(order)
      @order = order
      super()
    end

    def call
      delete_order
    end

    def delete_order
      @order.destroy
    end
  end
end
