# frozen_string_literal: true

module Api
  module V1
    # module Customer
    # Class to manage order lines since api
    class OrderLinesController < ApiController
      before_action :set_order
      before_action :authorize_request
      before_action :authorize_action

      # Method to add a produst to a shopping cart api endpoint
      # - POST /api/v1/order_lines
      def create
        @order_line = Customer::OrderLines::OrderLineCreator.call(order_line_form_params, @current_user, nil, @token)
        render json: json_api_format(OrderLineRepresenter.new(@order_line), 'order_line'), status: :ok
      end

      private

      def order_line_form_params
        params.require(:forms_order_line_form).permit(:product_id, :price, :quantity, :order_id)
      end

      def authorize_action
        authorize OrderLine
      end

      # Method to set a specific order line
      def set_order
        @order = Order.find(order_line_form_params[:order_id])
      end
    end
    # end
  end
end
