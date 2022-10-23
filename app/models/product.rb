class Product < ApplicationRecord
  # Associations
  has_many :order_lines, dependent: :destroy
  has_many :orders, through: :order_lines

  # Scopes
  default_scope { order(:name) }
end
