class ProductsController < ApplicationController
  before_action :set_product, only: %i[show]

  # GET /products
  def index
    @products = Product.all.available_products
    @virtual_order = Order.find(session[:order_id]) if session[:order_id]
  end

  # GET /products/:id
  def show; end

  # GET /search
  # Method to search a product by the name
  def search_product
    search = params[:search].downcase
    @products = Product.where('LOWER(name) LIKE ?', "%#{search}%")
    render :index
  end

  private

  # Method to find a prodcut by id
  def set_product
    @product = Product.find(params[:id])
  end
end
