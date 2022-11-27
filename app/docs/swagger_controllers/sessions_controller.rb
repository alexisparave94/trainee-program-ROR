# frozen_string_literal: true

module SwaggerControllers
  class SessionsController
    include Swagger::Blocks
    swagger_path '/sign_in' do
      operation :post do
        key :summary, 'Sign in'
        key :description, 'Returns a single user and jwt'
        key :operationId, 'signIn'
        key :tags, [
          'session'
        ]
        parameter name: :credentials, in: :body do
          key :description, 'Account to sign in'
          key :required, true
          schema '$ref': :Credentials
        end
        response 200 do
          key :description, 'Product response'
          schema '$ref': :Session
        end
        response 401 do
          key :description, 'Unauthorized'
          schema '$ref': :ErrorModel
        end
      end
    end
  end
end
