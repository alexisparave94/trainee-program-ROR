class Cart < ApplicationRecord
  has_many :order_lines, dependent: :destroy
end
