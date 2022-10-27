class OrderLine < ApplicationRecord
  # Associations
  belongs_to :order, optional: true
  belongs_to :product
  belongs_to :cart, optional: true

  # Callbacks
  # before_create :set_price
  # before_create :calculate_total
  # after_create :update_order_total

  # Validations
  # validates :product, uniqueness: { scope: :order, message: "This product already is include in the order" }
  validates :quantity, numericality: { only_integer: true, message: 'Must be an integer' }
  validates :quantity, numericality: { greater_than_or_equal_to: 0, message: 'Must be a positive number' }

  private

  # def set_price
  #   self.price = product.price
  # end

  # def calculate_total
  #   self.total = quantity * price
  # end

  # def update_order_total
  #   order.total += total
  #   order.save
  # end
end
