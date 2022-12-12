# frozen_string_literal: true

module Operations
  module Auth
    module Jwt
      # Class to manage operation to decode a jwt token
      class TokenDecode < Trailblazer::Operation
        SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
        # SECRET_KEY = ENV.fetch('SECRET_KEY_BASE', nil)

        step :decode

        def decode(ctx, token:, **)
          decoded = JWT.decode(token, SECRET_KEY)[0]
          ctx[:token_decoded] = HashWithIndifferentAccess.new(decoded)
        end
      end
    end
  end
end
