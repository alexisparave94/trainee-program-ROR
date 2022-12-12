# frozen_string_literal: true

module Contracts
  module Users
    # Class to manage the form to create a product comment
    class Create < Reform::Form
      property :first_name
      property :last_name
      property :email
      property :personal_email, virtual: true
      property :role
      property :password

      VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

      # Validations
      validates :email, presence: { message: 'Must enter an email' }
      validates :email, format: { with: VALID_EMAIL_REGEX, message: 'Must enter a valid e-mail format' }
      validates :personal_email, presence: { message: 'Must enter an email' }
      validates :personal_email, format: { with: VALID_EMAIL_REGEX, message: 'Must enter a valid e-mail format' }
      validate :uniq_email

      def uniq_email
        return unless User.find_by(email:)

        errors.add(:email, 'Email has been already taken')
      end
    end
  end
end
