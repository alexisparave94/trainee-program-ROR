class Admin::ProductsController < ApplicationController
  before_action :set_product, only: %i[edit update destroy]
  before_action :authenticate_user!, only: %i[new create edit update destroy]

  def new
    @product = Product.new
    authorize @product
  end

  def create
    @product = Product.new(product_params)
    authorize @product
    if @product.save
      redirect_to products_path, notice: 'Product was successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @product
  end

  def update
    authorize @product
    if @product.update(product_params)
      redirect_to products_path, notice: 'Product was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @product
    @product.destroy
    redirect_to products_path, notice: 'Product was successfully deleted'
  end

  private

  def product_params
    params.require(:product).permit(:sku, :name, :description,:price, :stock)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
