# frozen_string_literal: true

# Class to handle no enough stock
class NotEnoughStock < StandardError
  attr_reader :status, :error, :message

  def initialize(error = nil, status = nil, message = nil)
    super()
    @error = { exceed_stock: error } || 422
    @status = status || :unprocessable_entity
    @message = message || 'Not enough stock'
  end

  def fetch_json
    Helpers::Render.json(error, message, status)
  end
end
