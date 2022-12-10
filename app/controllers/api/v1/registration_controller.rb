# frozen_string_literal: true

module Api
  module V1
    # Class to manage registration with outh and fecabook
    class RegistrationController < ApiController
      # skip_before_action :doorkeeper_authorize!, only: %i[create]

      def create
        response = OauthRegistration.call(user_params)
        render json: response, status: :ok
      end

      private

      def user_params
        params.require(:data).permit(:facebook_token, :provider)
      end
    end
  end
end
