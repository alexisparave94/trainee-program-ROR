# frozen_string_literal: true

# Class to manage interactions betweeen users an orders
class OrdersController < ApplicationController
  # Method to delete an order
  # DELETE /orders/:id
  # @deprecated
  def destroy
    @virtual_order = Order.find(params[:id])
    @virtual_order.destroy
    session[:order_id] = nil
    redirect_to products_path, notice: 'Shopping cart was successfully deleted'
  end
end
