# frozen_string_literal: true

# Class to handle no authorization error
class NotAuthorizeUser < StandardError
  attr_reader :status, :error, :message

  def initialize(error = nil, status = nil, message = nil)
    super()
    @error = error || 401
    @status = status || :unauthorized
    @message = message || 'Something went wrong'
  end

  def fetch_json
    Helpers::Render.json(error, message, status)
  end
end
