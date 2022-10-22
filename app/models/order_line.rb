class OrderLine < ApplicationRecord
  # Associations
  belongs_to :order
  belongs_to :product

  # Callbacks
  before_create :set_price
  before_create :calculate_total
  after_create :update_order_total

  private

  def set_price
    self.price = product.price
  end

  def calculate_total
    self.total = quantity * price
  end

  def update_order_total
    order.total += total
    order.save
  end
end
