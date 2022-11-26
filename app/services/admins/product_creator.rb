# frozen_string_literal: true

module Admins
  # Service object to create a product
  class ProductCreator < Admins::AdminProductService
    def call
      validate_params(Forms::NewProductForm.new(@params))
      @product = Product.create(@params)
      save_change_log
      @product
    end

    private

    # Method to save changes in the product in change log
    def save_change_log
      @log = ChangeLog.new(user: @user, product: @product.name, description: 'Create')
      @log.save
    end
  end
end
