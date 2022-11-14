# frozen_string_literal: true

# Service object to delete a product
class ProductDeleter < ApplicationService
  def initialize(product)
    @product = product
    super()
  end

  def call
    delete_product
  end

  private

  def delete_product
    @product.destroy
  end
end
