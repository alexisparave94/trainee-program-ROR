class OrdersController < ApplicationController
  # GET /orders/:id
  def show; end

  # DELETE /orders/:id
  def destroy
    @virtual_order = Order.find(params[:id])
    @virtual_order.destroy
    session[:order_id] = nil
    redirect_to products_path, notice: 'Shopping cart was successfully deleted'
  end
end
