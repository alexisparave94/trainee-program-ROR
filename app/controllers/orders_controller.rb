class OrdersController < ApplicationController
  def show
    @virtual_order = Order.find(params[:id])
  end

  def destroy
    @virtual_order = Order.find(params[:id])
    @virtual_order.destroy
    session[:order_id] = nil
    redirect_to products_path, notice: 'Shopping cart was successfully deleted'
  end

  def empty_cart
    OrderLine.destroy_by(order_id: params[:order_id])
    redirect_to Order.find(params[:order_id]), notice: 'Shopping cart has been emptied successfully'
  end

  def checkout
    @virtual_order = Order.find(session[:order_id])
    session[:checkout] = @virtual_order.lines_exceed_stock.compact
    render :show
  end
end
