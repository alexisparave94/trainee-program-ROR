# frozen_string_literal: true

module Admins
  # Service object to create a product
  class ProductUpdater < ApplicationService
    def initialize(params, product_id, user = nil)
      @params = params
      @product = Product.find(product_id)
      @user = user
      super()
    end

    def call
      update_params if @user.support?
      @product_form = Forms::ProductForm.new(@params)
      raise(NotValidEntryRecord, parse_errors) unless @product_form.valid?

      @product.update(@params)
      @product
    end

    private

    def parse_errors
      @product_form.errors.messages.map { |_key, error| error }.join(', ')
    end

    def update_params
      @params = @params.merge(price: @product.price)
    end
  end
end
