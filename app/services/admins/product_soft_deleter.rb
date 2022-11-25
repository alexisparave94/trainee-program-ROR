# frozen_string_literal: true

module Admins
  # Service object to soft delete a product
  class ProductSoftDeleter < ApplicationService
    def initialize(product, user)
      @product = product
      @user = user
      super()
    end

    def call
      save_change_log
      soft_delete_product
      @product
    end

    private

    def soft_delete_product
      @product.discard
    end

    # Method to save changes in the product in change log
    def save_change_log
      @log = ChangeLog.new(user: @user, product: @product.name, description: 'Soft Delete')
      @log.save
    end
  end
end
