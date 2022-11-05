# frozen_string_literal: true

# Class of the namespace Admin
module Admin
  # Class to manage Products Controller
  class ProductsController < ApplicationController
    before_action :set_product, only: %i[edit update destroy]
    before_action :authenticate_user!, only: %i[new create edit update destroy]

    # GET /admin/products/new
    def new
      @product = Product.new
      authorize @product
    end

    # POST /admin/products
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

    # GET /admin/products/:id/edit
    def edit
      authorize @product
    end

    # PATCH /admin/products/:id
    def update
      authorize @product
      User.set_user(current_user)
      if @product.update(product_params)
        redirect_to products_path, notice: 'Product was successfully updated'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    # DELETE /admin/products/:id
    def destroy
      authorize @product
      @product.destroy
      save_change_log(request.request_method)
      redirect_to products_path, notice: 'Product was successfully deleted'
    end

    private

    def product_params
      params.require(:product).permit(:sku, :name, :description, :price, :stock)
    end

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
