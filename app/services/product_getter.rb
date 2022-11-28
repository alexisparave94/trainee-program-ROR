# frozen_string_literal: true

# Service object to show a product
class ProductGetter < ApplicationService
  def initialize(product_id, user = nil)
    @product = Product.find(product_id)
    @user = user
    super()
  end

  def call
    # available_product
    @product
  end

  private

  def available_product
    raise(NotValidEntryRecord, 'Products has been disabled') if @product.discarded? && (@user.nil? || @user.customer?)

    @product
  end
end
