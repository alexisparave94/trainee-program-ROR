# frozen_string_literal: true

module Admins
  # Service object to delete a product
  class ProductDeleter < ApplicationService
    def initialize(product, user)
      @product = product
      @user = user
      super()
    end

    def call
      save_change_log
      delete_product
    end

    private

    def delete_product
      @product.destroy
    end

    # Method to save changes in the product in change log
    def save_change_log
      @log = ChangeLog.new(user: @user, product: @product.name, description: 'Delete')
      @log.save
    end
  end
end
