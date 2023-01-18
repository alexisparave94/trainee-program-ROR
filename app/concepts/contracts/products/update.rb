# frozen_string_literal: true

module Contracts
  module Products
    # Class to manage the form to update a product
    class Update < Reform::Form
      property :sku
      property :name
      property :description
      property :price
      property :stock
      property :image

      validates :sku, presence: { message: 'Must enter a sku' }
      # validate :uniq_sku
      validates :name, presence: { message: 'Must enter a name' }
      # validate :uniq_name
      validates :stock, numericality: { only_integer: true, message: ' Stock must be an integer' }
      validates :stock, numericality: { greater_than_or_equal_to: 0, message: 'Stock must be a positive number' }
      validates :price, numericality: { greater_than: 0, message: 'Price must be a positive number greater than 0' },
                        allow_nil: true

      def uniq_name
        return unless Product.find_by(name:)

        errors.add(:name, 'Name has been already taken')
      end

      def uniq_sku
        return unless Product.find_by(sku:)

        errors.add(:sku, 'SKU has been already taken')
      end
    end
  end
end
