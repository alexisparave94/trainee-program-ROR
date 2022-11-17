# frozen_string_literal: true

module Helpers
  # Class for render error
  class Render
    def self.json(error, status, message)
      { error:, status:, message: }.as_json
    end
  end
end
