class OrdersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  def show_cart
    @lines_exceed_stock = session[:checkout]
    # @virtual_order = session[:virtual_order]
    @virtual_order = Order.find(session[:order_id])
  end

  def destroy; end

  def empty_cart
    OrderLine.destroy_by(order_id: params[:order_id])
    redirect_to show_cart_path, notice: 'Shopping cart has been emptied successfully'
  end

  def checkout
    @virtual_order = session[:virtual_order]
    @lines_exceed_stock = @virtual_order.map do |detail|
      stock = Product.find(detail['product']['id']).stock
      current_quantity = detail['order_line']['quantity']
      stock < current_quantity ? { product: detail['product'], stock: } : nil
    end

    session[:checkout] = @lines_exceed_stock.compact!
    render :show_cart
  end
end
