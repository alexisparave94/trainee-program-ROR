# frozen_string_literal: true

module Forms
  # Class to manage Product Form model
  class ProductForm
    include ActiveModel::Model

    attr_accessor :name, :sku, :description, :stock, :price

    # Validations
    validates :name, presence: { message: 'Must enter a name' }
    # validates :name, uniqueness: { message: 'Name "%<value>s" already exists' }
    validates :sku, presence: { message: 'Must enter a sku' }
    # validates :sku, uniqueness: { message: 'Sku "%<value>s" already exists' }
    validates :stock, numericality: { only_integer: true, message: 'Must be an integer' }
    validates :stock, numericality: { greater_than_or_equal_to: 0, message: 'Must be a positive number' }
    validates :price, numericality: { greater_than: 0, message: 'Must be a positive number greater than 0' }

    def initialize(attr = {}, current_user = nil)
      @current_user = current_user
      if attr[:id].nil?
        super(attr)
      else
        @product = Product.find(attr[:id])
        set_attributes
      end
    end

    def persisted?
      !@product.nil?
    end

    def id
      @product.nil? ? nil : @product.id
    end

    def update
      return false unless valid?

      @product.update(name:, sku:, description:, stock:, price:)
    end

    private

    def set_attributes
      self.name = attr[:name].nil? ? @product.name : attr[:name]
      self.sku = attr[:sku].nil? ? @product.sku : attr[:sku]
      self.description = attr[:description].nil? ? @product.description : attr[:description]
      self.price = attr[:price].nil? ? @product.price : attr[:price]
      self.stock = attr[:stock].nil? ? @product.stock : attr[:stock]
    end
  end
end
