class Product < ApplicationRecord
  # Associations
  has_many :order_lines, dependent: :destroy
  has_many :orders, through: :order_lines

  # Scopes
  default_scope { order(:name) }
  scope :order_by_price, -> { order(:price) }
  scope :get_most_purchased_product, -> { joins(order_lines: :order).where('orders.status': 1).group(:id).order('SUM(order_lines.quantity) DESC').limit(1) }
end
