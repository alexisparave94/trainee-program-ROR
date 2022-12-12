# frozen_string_literal: true

module Operations
  module Api
    module V1
      module Session
        module Jwt
          # Class to manage operation of create a session with jwt
          class Create < Trailblazer::Operation
            step :set_user
            step :authenticate_user

            def set_user(ctx, params:, **)
              ctx[:user] = User.find_by(email: params[:email])
            end

            def authenticate_user(ctx, params:, user:, **)
              raise(NotAuthorizeUser, 'Your account has been disabled') if user.discarded?
              raise(NotAuthorizeUser, 'Invalid credentials') unless user.valid_password?(params[:password])

              ctx[:token] = Operations::Auth::Jwt::TokenEncode.call(user:)[:token_encoded]
            end
          end
        end
      end
    end
  end
end
