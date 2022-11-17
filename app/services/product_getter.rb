# frozen_string_literal: true

# Service object to show a product
class ProductGetter < ApplicationService
  def initialize(product_id)
    @product_id = product_id
    super()
  end

  def call
    Product.find(@product_id)
  end
end
