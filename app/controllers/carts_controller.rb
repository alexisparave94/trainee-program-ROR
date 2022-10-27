class CartsController < ApplicationController
  before_action :set_cart

  def show; end

  def destroy
    @cart.destroy if @cart.id == session[:cart_id]
    session[:cart_id] = nil
    redirect_to products_path, notice: 'Your cart has been emptied'
  end

  private

  def set_cart
    @cart = Cart.find(params[:id])
  end
end
