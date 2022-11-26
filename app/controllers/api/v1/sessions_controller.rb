# frozen_string_literal: true

module Api
  module V1
    # Class to manage interactions between no logged in users and products
    class SessionsController < ApiController
      include Swagger::Blocks

      # Method to get index of products
      # GET /pai/v1/products
      # swagger_path '/sign_in' do
      #   operation :post do
      #     key :summary, 'Sign in'
      #     key :description, 'Returns a single user and jwt'
      #     key :operationId, 'signIn'
      #     key :tags, [
      #       'session'
      #     ]
      #     parameter name: :credentials, in: :body do
      #       key :description, 'Account to sign in'
      #       key :required, true
      #       schema '$ref': :Credentials
      #     end
      #     response 200 do
      #       key :description, 'Product response'
      #       schema '$ref': :Session
      #     end
      #     response 401 do
      #       key :description, 'Unauthorized'
      #       schema '$ref': :ErrorModel
      #     end
      #   end
      # end

      def sign_in
        @token, @user = SessionService.call(params)
        render json: json_api_format(
          { token: @token, first_name: @user.first_name, email: @user.email }, 'session'
        ), status: :ok
      end
    end
  end
end
