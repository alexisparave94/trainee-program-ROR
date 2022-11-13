# frozen_string_literal: true

module Admin
  # Service object to create a product
  class ProductCreator < ApplicationService
    class NotValidEntryRecord < StandardError; end

    def initialize(params, user)
      @params = params
      @user = user
      super()
    end

    def call
      @product_form = Forms::ProductForm.new(@params)
      raise(NotValidEntryRecord, parse_errors) unless @product_form.valid?

      @product = Product.create(name: @params[:name],
                                sku: @params[:sku],
                                description: @params[:description],
                                stock: @params[:stock],
                                price: @params[:price])
      save_change_log('Create')
    end

    private

    def parse_errors
      @product_form.errors.messages.map { |_key, error| error }.join(', ')
    end

    # Method to save changes in the product in change log
    def save_change_log(description)
      @log = ChangeLog.new(user: @user, product: @product.name, description:)
      @log.save
    end
  end
end
