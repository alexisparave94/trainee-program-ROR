# frozen_string_literal: true

module Admins
  # Service object to create a product
  class ProductCreator < ApplicationService
    def initialize(params, user, token = nil)
      @params = params
      @user = user
      @token = token
      super()
    end

    def call
      @product_form = Forms::NewProductForm.new(@params)
      handle_error
      @product = Product.create(@params)
      save_change_log('Create')
      @product
    end

    private

    def parse_errors
      @product_form.errors.messages.map { |_key, error| error }.join(', ')
    end

    def parse_errors_api
      @product_form.errors.messages
    end

    # Method to save changes in the product in change log
    def save_change_log(description)
      @log = ChangeLog.new(user: @user, product: @product.name, description:)
      @log.save
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
