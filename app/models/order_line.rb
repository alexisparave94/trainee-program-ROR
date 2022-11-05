# frozen_string_literal: true

# Class to manage OrderLine Model
class OrderLine < ApplicationRecord
  # Associations
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :cart, optional: true

  # Callbacks
  before_save :calculate_total

  # Validations
  validates :quantity, numericality: { only_integer: true, message: 'Quantity must be an integer' }
  validates :quantity,
            numericality: { greater_than_or_equal_to: 1, message: 'Quantity must be a positive number greather than 0' }

  private

  def calculate_total
    self.total = quantity * price
  end
end
