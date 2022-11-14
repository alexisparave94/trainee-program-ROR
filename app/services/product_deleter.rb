# frozen_string_literal: true

class ProductDeleter < ApplicationService
  def initialize(product)
    @product = product
  end

  def call
    delete_product
  end

  private

  def delete_product
    @product.destroy
  end
end
