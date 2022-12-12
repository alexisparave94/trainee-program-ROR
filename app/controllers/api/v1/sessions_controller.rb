# frozen_string_literal: true

module Api
  module V1
    # Class to manage interactions between no logged in users and products
    class SessionsController < ApiController
      # Method to sign in
      # GET /api/v1/sign_in
      def sign_in
        # @token, @user = SessionService.call(params)
        ctx = run Operations::Api::V1::Session::Jwt::Create
        render json: json_api_format(
          { token: ctx[:token], first_name: ctx[:user].first_name, email: ctx[:user].email }, 'session'
        ), status: :ok
      end
    end
  end
end
