# frozen_string_literal: true

module Api
  module V1
    # module Customer
    # Class to manage shopping cart since api
    class ShoppingCartController < ApiController
      before_action :authorize_request
      before_action :authorize_action

      # Method to checkout if there is enough stock for all the products of a shopping cart
      # - GET /api/v1/customer/checkout
      # def checkout
      #   @order = Customer::CheckoutHandlerApi.call(params[:order_id])
      #   # puts 'Herrrrrrr'
      #   # authorize Order
      #   render json: json_api_format(OrderRepresenter.new(@order), 'order'), status: :ok
      # end
    end
    # end

    # private

    # def authorize_action
    #   authorize Order
    # end
  end
end
