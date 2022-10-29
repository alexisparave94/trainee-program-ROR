class ProductsController < ApplicationController
  before_action :set_product, only: %i[show]

  def index
    @products = Product.all
    @virtual_order = Order.find(session[:order_id]) if session[:order_id]
  end

  def show; end

  def search_product
    search = params[:search].downcase
    @products = Product.where('LOWER(name) LIKE ?', "%#{search}%")
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
