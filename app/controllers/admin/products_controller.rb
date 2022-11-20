# frozen_string_literal: true

# Class of the namespace Admin
module Admin
  # Class to manage interactions between admin users and products
  class ProductsController < ApplicationController
    before_action :set_product
    before_action :authenticate_user!
    before_action :authorize_action

    # Method to delete a product
    # - DELETE /admin/products/:id
    def destroy
      Admins::ProductDeleter.call(@product, @current_user)
      redirect_to products_path, notice: 'Product was successfully deleted'
    end

    def add_tag
      Admins::TagAdder.call(params[:tag_id], @product)
      redirect_to @product, notice: 'Tag was successfully added'
    end

    private

    # Method to set a specific product
    def set_product
      @product = Product.find(params[:id])
    end

    # Method to authorize actions
    def authorize_action
      authorize Product
    end
  end
end
