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
      @product_form = Forms::EditProductForm.new(@params)
      handle_error
      @changed_attributes = set_changed_attributes
      @product.update(@params)
      save_change_log
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

    # Method to save changes in the product in change log
    def save_change_log
      @changed_attributes.each do |attr|
        ChangeLog.create(
          user: @user,
          description: 'Update',
          product: @product.name,
          field: attr[0],
          previous_content: attr[1],
          new_content: attr[2]
        )
      end
    end

    def set_changed_attributes
      attr_before_update = @product.attributes.except('id', 'created_at', 'updated_at', 'likes_count', 'image')
      params_hash = @params.to_hash.except('image')
      params_hash.map { |key, value| value == attr_before_update[key] ? nil : [key, attr_before_update[key], value] }
                 .compact
    end
  end
end
