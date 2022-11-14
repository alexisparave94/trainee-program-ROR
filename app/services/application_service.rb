# frozen_string_literal: true

# Class parent for service objects
class ApplicationService
  def self.call(*args)
    new(*args).call
  end
end
