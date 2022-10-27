class ProductsController < ApplicationController
  before_action :set_product, only: %i[show edit update destroy]

  def index
    @products = Product.all
    @cart = Cart.find(session[:cart_id]) if session[:card_id]
  end

  def show; end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    if @product.save
      redirect_to products_path, notice: 'Product was successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @product.update(product_params)
      redirect_to products_path, notice: 'Product was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product.destroy
    redirect_to products_path, notice: 'Company was successfully destroyed'
  end

  def search_product
    search = params[:search].downcase
    @products = Product.where("LOWER(name) LIKE ?", "%#{search}%")
    render :index
  end

  private

  def product_params
    params.require(:product).permit(:sku, :name, :description,:price, :stock)
  end

  def set_product
    @product = Product.find(params[:id])
  end
end
