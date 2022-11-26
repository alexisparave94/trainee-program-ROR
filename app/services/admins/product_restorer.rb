# frozen_string_literal: true

module Admins
  # Service object to restore a product
  class ProductRestorer < ApplicationService
    def initialize(product, user)
      @product = product
      @user = user
      super()
    end

    def call
      raise(NotValidEntryRecord, 'Product is not discarted') unless @product.discarded?

      restore_product
      save_change_log
      @product
    end

    private

    def restore_product
      @product.undiscard
    end

    # Method to save changes in the product in change log
    def save_change_log
      @log = ChangeLog.new(user: @user, product: @product.name, description: 'Restore')
      @log.save
    end
  end
end
