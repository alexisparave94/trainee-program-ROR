# frozen_string_literal: true

module Contracts
  module Passwords
    # Class to manage validations to reset password
    class ResetPassword < Reform::Form
      property :email

      validates :email, presence: { message: 'Must enter an email' }
      validate :check_register_email

      def check_register_email
        return unless User.find_by(email:).nil?

        errors.add(:email, 'Invalid email')
      end
    end
  end
end
