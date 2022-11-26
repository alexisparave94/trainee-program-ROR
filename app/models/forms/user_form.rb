# frozen_string_literal: true

module Forms
  # Class to manage User Form model
  class UserForm
    include ActiveModel::Model

    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

    attr_accessor :first_name, :last_name, :email, :password

    # Validations
    validates :email, presence: { message: 'Must enter an email' }
    validates :email, format: { with: VALID_EMAIL_REGEX, message: 'Must enter a valid e-mail format' }
    validate :uniq_email
    validates :password, presence: { message: 'Must enter a password' }

    def uniq_email
      return unless User.find_by(email:)

      errors.add(:email, 'Email has been already taken')
    end
  end
end
