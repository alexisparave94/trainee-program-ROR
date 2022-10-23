class Order < ApplicationRecord
  # Associations
  belongs_to :customer
  has_many :order_lines, dependent: :destroy
  has_many :products, through: :order_lines

  # Enum
  enum :status, %i[pending completed refused]
end
