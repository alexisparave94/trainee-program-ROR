class ProductsController < ApplicationController
  before_action :set_product, only: %i[show]

  def index
    @products = Product.all.available_products
    @virtual_order = Order.find(session[:order_id]) if session[:order_id]
  end

  def show; end

  def search_product
    search = params[:search].downcase
    @products = Product.where('LOWER(name) LIKE ?', "%#{search}%")
    render :index
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
