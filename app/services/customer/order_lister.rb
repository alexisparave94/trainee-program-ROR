# frozen_string_literal: true

module Customer
  # Service object to empty a shopping cart
  # for a logged in customer user
  class OrderLister < ApplicationService
    def initialize(current_user, status)
      @current_user = current_user
      @status = status
      super()
    end

    def call
      list_orders
    end

    private

    attr_reader :status, :current_user

    def list_orders
      OrdersQuery.new({ status: }, current_user.orders).completed_orders
    end
  end
end
