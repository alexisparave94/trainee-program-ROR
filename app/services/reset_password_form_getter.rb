# frozen_string_literal: true

# Service object to get form to reset a password
class ResetPasswordFormGetter < ApplicationService
  def call
    User.new
  end
end
