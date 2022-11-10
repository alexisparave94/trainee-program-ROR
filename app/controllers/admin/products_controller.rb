# frozen_string_literal: true

# Class of the namespace Admin
module Admin
  # Class to manage interactions between admin users and products
  class ProductsController < ApplicationController
    before_action :set_product, only: %i[edit update destroy]
    before_action :authenticate_user!, only: %i[new create edit update destroy]

    # Method to get the form to create a new product
    # - GET /admin/products/new
    def new
      @product = Product.new
      authorize @product
    end

    # Method to create a new product
    # - POST /admin/products
    def create
      @product = Product.new(product_params)
      authorize @product
      if @product.save
        save_change_log(request.request_method)
        redirect_to products_path, notice: 'Product was successfully created'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # Method to get the form to edit a new product
    # - GET /admin/products/:id/edit
    def edit
      authorize @product
    end

    # Method to update a product
    # - PATCH /admin/products/:id
    def update
      authorize @product
      User.define_user(current_user)
      if @product.update(product_params)
        redirect_to products_path, notice: 'Product was successfully updated'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # Method to delete a product
    # - DELETE /admin/products/:id
    def destroy
      authorize @product
      ProductDeleter.call(@product)
      save_change_log(request.request_method)
      redirect_to products_path, notice: 'Product was successfully deleted'
    end

    private

    # Method to set strong paramas for product
    def product_params
      params.require(:product).permit(:sku, :name, :description, :price, :stock)
    end

    # Method to set a specific product
    def set_product
      @product = Product.find(params[:id])
    end

    # Method to save changes in the product in change log
    def save_change_log(request_method)
      @log = ChangeLog.new(user: current_user, product: @product.name)
      @log.format_description(request_method)
      @log.save
    end
  end
end
