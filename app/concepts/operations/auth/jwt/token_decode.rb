# frozen_string_literal: true

module Operations
  module Auth
    module Jwt
      # Class to manage operation to show form to reset a password
      class TokenDecode < Trailblazer::Operation
        SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
        # SECRET_KEY = ENV.fetch('SECRET_KEY_BASE', nil)

        step :decode

        def decode(ctx, token:, **)
          decoded = JWT.decode(token, SECRET_KEY)[0]
          ctx[:token_decoded] = HashWithIndifferentAccess.new(decoded)
        end

        # def initialize(token)
        #   @token = token
        #   super()
        # end

        # def call
        #   decode
        # end

        # private

        # def decode
        #   decoded = JWT.decode(@token, SECRET_KEY)[0]
        #   HashWithIndifferentAccess.new decoded
        # end
      end
    end
  end
end
