# frozen_string_literal: true

module SwaggerControllers
  class OrdersController
    include Swagger::Blocks
    swagger_path '/orders' do
      operation :get do
        key :description, 'Returns all orders of a user'
        key :operationId, 'findOrders'
        key :tags, ['orders']
        security Bearer: []
        response 200, description: 'Orders response' do
          schema '$ref': :OrdersResponse
        end
        response 422, description: 'Unprocessable entity' do
          schema '$ref': :ErrorModel
        end
      end
    end
  end
end
