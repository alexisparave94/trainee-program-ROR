# frozen_string_literal: true

module Admins
  # Service object to create a product
  class ProductUpdater < ApplicationService
    def initialize(params, product_id, user = nil, token = nil)
      @params = params
      @product = Product.find(product_id)
      @user = user
      @token = token
      super()
    end

    def call
      update_params if @user.support?
      @product_form = Forms::ProductForm.new(@params)
      handle_error

      @product.update(@params)
      @product
    end

    private

    def parse_errors
      @product_form.errors.messages.map { |_key, error| error }.join(', ')
    end

    def parse_errors_api
      @product_form.errors.messages
    end

    def update_params
      @params = @params.merge(price: @product.price)
    end

    def handle_error
      if @token
        raise(NotValidEntryRecord, parse_errors_api) unless @product_form.valid?
      else
        raise(StandardError, parse_errors) unless @product_form.valid?
      end
    end
  end
end
