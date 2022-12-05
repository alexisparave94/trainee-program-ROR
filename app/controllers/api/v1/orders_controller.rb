# frozen_string_literal: true

module Api
  module V1
    # Class to manage orders since api
    class OrdersController < ApiController
      before_action :authorize_request, only: %i[index checkout]
      before_action :set_order, only: %i[checkout]

      # Method to get index of completed orders of a customer user
      # - GET api/v1/orders
      def index
        authorize Order
        @orders = Customer::OrderLister.call(@current_user, 'completed')
        render json: json_api_format(OrderRepresenter.for_collection.new(@orders), 'orders'), status: :ok
      end

      # Method to checkout if there is enough stock for all the products of a shopping cart
      # - GET /api/v1/customer/checkout
      def checkout
        authorize @order
        # @order = Customer::CheckoutHandlerApi.call(params[:order_id])
        session = Customer::StripeCheckoutApiService.call(@current_user, @order, root_url, root_url)
        render json: session, status: :ok
      end

      private

      def set_order
        @order = Order.find(params[:order_id])
      end
    end
  end
end
