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

  private

  def calculate_total
    self.total = quantity * price
  end
end
