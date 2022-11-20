# frozen_string_literal: true

module Forms
  # Class to manage Product Form model
  class NewProductForm
    include ActiveModel::Model

    attr_accessor :name, :sku, :description, :stock, :price, :product, :image

    # Validations
    validates :sku, presence: { message: 'Must enter a sku' }
    validate :uniq_sku
    validates :name, presence: { message: 'Must enter a name' }
    validate :uniq_name
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
