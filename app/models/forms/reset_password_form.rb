# frozen_string_literal: true

module Forms
  # Class to manage Reset Password Form
  class ResetPasswordForm
    include ActiveModel::Model

    attr_accessor :email

    # Validations
    validates :email, presence: { message: 'Must enter an email' }
    validate :check_register_email

    def check_register_email
      return unless User.find_by(email:).nil?

      errors.add(:email, 'Invalid email')
    end
  end
end
