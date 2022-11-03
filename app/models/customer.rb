# frozen_string_literal: true

class Customer < ApplicationRecord
  # Associations
  has_many :orders, dependent: :nullify

  # Validations
  validates :first_name, length: { minimum: 2, message: 'Must enter a valid first or last name', if: lambda {
                                                                                                       last_name.nil?
                                                                                                     } }
  validates :last_name, length: { minimum: 2, message: 'Must enter a valid first or last name', if: lambda {
                                                                                                      first_name.nil?
                                                                                                    } }
end
