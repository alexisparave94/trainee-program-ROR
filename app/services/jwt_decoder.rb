# frozen_string_literal: true

# Service object to encode a jwt
class JwtDecoder < ApplicationService
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  # SECRET_KEY = ENV.fetch('SECRET_KEY_BASE', nil)

  def initialize(token)
    @token = token
    super()
  end

  def call
    decode
  end

  private

  def decode
    decoded = JWT.decode(@token, SECRET_KEY)[0]
    HashWithIndifferentAccess.new decoded
  end
end
