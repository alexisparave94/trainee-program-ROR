class Customer < ApplicationRecord
  # Associations
  has_many :orders, dependent: :nullify
end
