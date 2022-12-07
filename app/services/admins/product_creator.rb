# frozen_string_literal: true

module Admins
  # Service object to create a product
  class ProductCreator < Admins::AdminProductService
    def call
      validate_params(Forms::NewProductForm.new(@params))
      @product = Product.create(@params)
      create_stripe_product
      save_change_log
      @product
    end

    private

    # Method to save changes in the product in change log
    def save_change_log
      @log = ChangeLog.new(user: @user, product: @product.name, description: 'Create')
      @log.save
    end

    def create_stripe_product
      stripe_product = Stripe::Product.create(name: @product.name)
      Stripe::Price.create(product: stripe_product, unit_amount: @product.price, currency: 'usd')
      @product.update(stripe_product_id: stripe_product.id)
    end
  end
end
