# frozen_string_literal: true

module Api
  module V1
    # Class to manage orders since api
    class OrdersController < ApiController
      before_action :authorize_request, only: %i[index]

      # Method to get index of completed orders of a customer user
      # - GET api/v1/orders
      def index
        authorize Order
        @orders = Customer::OrderLister.call(@current_user, 'completed')
        render json: @orders, status: :ok
      end
    end
  end
end
