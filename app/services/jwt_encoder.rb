# frozen_string_literal: true

# Service object to encode a jwt
class JwtEncoder < ApplicationService
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  # SECRET_KEY = ENV.fetch('SECRET_KEY_BASE', nil)

  # def initialize(payload, exp = 2.seconds.from_now)
  def initialize(payload, exp = 4.hours.from_now)
    @payload = payload
    @exp = exp
    super()
  end

  def call
    encode
  end

  private

  def encode
    @payload[:exp] = @exp.to_i
    JWT.encode(@payload, SECRET_KEY)
  end
end
