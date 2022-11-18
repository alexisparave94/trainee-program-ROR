# frozen_string_literal: true

module Api
  module V1
    # Class to manage interactions between no logged in users and products
    class SessionsController < ApiController
      # Method to get index of products
      # GET /pai/v1/products
      def sign_in
        @user = User.find_by(email: params[:email])
        if @user.valid_password?(params[:password])
          token = JsonWebToken.encode(user_id: @user.id)
          render json: { token:, first_name: @user.first_name,
                         email: @user.email }, status: :ok
        else
          render json: { error: 'unauthorized' }, status: :unauthorized
        end
      end
    end
  end
end
