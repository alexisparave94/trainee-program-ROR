# frozen_string_literal: true

# Service object to show a product
class ProductShower < ApplicationService
  def initialize(product_id, user)
    @user = user
    @product_id = product_id
    super()
  end

  def call
    set_coment_product_form
  end

  def set_coment_product_form
    Forms::CommentProductForm.new({ product_id: @product_id }, @user)
  end
end
