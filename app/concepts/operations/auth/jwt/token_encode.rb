# frozen_string_literal: true

module Operations
  module Auth
    module Jwt
      # Class to manage operation to dencode a jwt token
      class TokenEncode < Trailblazer::Operation
        SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
        # SECRET_KEY = ENV.fetch('SECRET_KEY_BASE', nil)

        step :set_payload
        step :encode

        def set_payload(ctx, user:, **)
          ctx[:payload] = { user_id: user.id }
          exp = 4.hours.from_now
          ctx[:payload][:exp] = exp.to_i
        end

        def encode(ctx, payload:, **)
          ctx[:token_encoded] = JWT.encode(payload, SECRET_KEY)
        end
      end
    end
  end
end
