# frozen_string_literal: true

module Api
  module V1
    # Class to manage interactions between no logged in users and products
    class SessionsController < ApiController
      # Method to sign in
      # GET /api/v1/sign_in
      def sign_in
        @token, @user = SessionService.call(params)
        render json: json_api_format(
          { token: @token, first_name: @user.first_name, email: @user.email }, 'session'
        ), status: :ok
      end
    end
  end
end
