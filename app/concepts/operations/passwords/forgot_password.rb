# frozen_string_literal: true

module Operations
  module Passwords
    # Class to manage operation to show form to reset a password
    class ForgotPassword < Trailblazer::Operation
      step Model(User, :new)
    end
  end
end
