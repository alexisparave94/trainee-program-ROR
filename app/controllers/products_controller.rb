class ProductsController < ApplicationController
  before_action :set_product, only: %i[show]

  # GET /products
  def index
    @products = Product.all.available_products
    pp session[:order_id]
    pp session[:virtual_order]
    if params[:search]
      @search = params[:search].downcase
      @products = @products.where('LOWER(name) LIKE ?', "%#{@search}%")
    end
    # @virtual_order = Order.find(session[:order_id]) if session[:order_id]
  end

  # GET /products/:id
  def show; end

  private

  # Method to find a prodcut by id
  def set_product
    @product = Product.find(params[:id])
  end
end
