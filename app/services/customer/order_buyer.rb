# frozen_string_literal: true

module Customer
  # Service object to empty a shopping cart
  # for a logged in customer user
  class OrderBuyer < ApplicationService
    def initialize(order)
      @order = order
      super()
    end

    def call
      buy_order
    end

    private

    attr_reader :order

    def buy_order
      return false if order.completed?

      order.update(status: 'completed', total: @order.calculate_total)
      Customer::StockUpdater.call(order)
    end
  end
end
