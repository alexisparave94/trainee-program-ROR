# frozen_string_literal: true

module Contracts
  module OrderLines
    # Class to manage the form to add a product to an order line
    class Create < Reform::Form
      property :quantity
      property :price
      property :product_id
      property :order_id

      validates :quantity, numericality: { only_integer: true, message: 'Quantity must be an integer' }
      validates :quantity,
                numericality: { greater_than_or_equal_to: 1,
                                message: 'Quantity must be a positive number greather than 0' }
    end
  end
end
