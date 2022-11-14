# frozen_string_literal: true

# Class for decorators of orders
class ErrorFormDecorator < BaseDecorator
  decorates :error_form

  def list_errors(errors)
    errors.split(',').map { |error| "<li>#{error}</li>" }.join.html_safe
  end
end
