# frozen_string_literal: true

module Forms
  # Class to manage Product Form model
  class ProductForm
    include ActiveModel::Model

    attr_accessor :name, :sku, :description, :stock, :price, :product

    # Validations
    validates :name, presence: { message: 'Must enter a name' }
    validates :sku, presence: { message: 'Must enter a sku' }
    validates :stock, numericality: { only_integer: true, message: 'Must be an integer' }
    validates :stock, numericality: { greater_than_or_equal_to: 0, message: 'Must be a positive number' }
    validates :price, numericality: { greater_than: 0, message: 'Must be a positive number greater than 0' },
                      allow_nil: true

    def initialize(attr = {})
      if attr[:id].nil?
        super(attr)
      else
        @product = Product.find(attr[:id])
      end
    end

    def id
      @product.nil? ? nil : @product.id
    end
  end
end
