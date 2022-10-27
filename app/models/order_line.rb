class OrderLine < ApplicationRecord
  # Associations
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :cart, optional: true

  # Callbacks
  before_save :calculate_total

  # Validations
  validates :quantity, numericality: { only_integer: true, message: 'Must be an integer' }
  validates :quantity, numericality: { greater_than_or_equal_to: 0, message: 'Must be a positive number' }

  private

  def calculate_total
    self.total = quantity * price
  end
end
