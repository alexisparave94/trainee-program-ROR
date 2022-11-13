# frozen_string_literal: true

module Admin
  # Service object to create a product
  class ProductUpdater < ApplicationService
    class NotValidEntryRecord < StandardError; end

    def initialize(params, product_id)
      @params = params
      @product = Product.find(product_id)
      super()
    end

    def call
      @product_form = Forms::ProductForm.new(@params)
      raise(NotValidEntryRecord, parse_errors) unless @product_form.valid?

      @product.update(name: @params[:name],
                      sku: @params[:sku],
                      description: @params[:description],
                      stock: @params[:stock],
                      price: @params[:price])
    end

    private

    def parse_errors
      @product_form.errors.messages.map { |_key, error| error }.join(', ')
    end
  end
end
