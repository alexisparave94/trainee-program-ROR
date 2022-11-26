# frozen_string_literal: true

# Class parent for service objects
class ApplicationService
  def self.call(*args)
    new(*args).call
  end

  protected

  def parse_errors(object)
    object.errors.messages.map { |_key, error| error }.join(', ')
  end

  def parse_errors_api(object)
    object.errors.messages
  end

  def handle_error(object, token = nil)
    if token
      raise(NotValidEntryRecord, parse_errors_api(object)) unless object.valid?
    else
      raise(StandardError, parse_errors(object)) unless object.valid?
    end
  end
end
