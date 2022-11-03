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

  # GET /empty_cart
  # Method to delete all the lines of a shopping card
  def empty_cart
    if session[:order_id]
      OrderLine.destroy_by(order_id: params[:order_id])
    else
      session[:virtual_order] = nil
    end
    redirect_to shopping_cart_path, notice: 'Shopping cart has been emptied successfully'
  end

  # GET /checkout
  # Method to checkout if there is enough stock for all the products of a shopping cart
  def checkout
    if current_user
      @order = Order.find(session[:order_id])
      session[:checkout] = @order.lines_exceed_stock.compact
    else
      @virtual_order = session[:virtual_order]
      session[:checkout] = lines_exceed_stock.compact
    end
    redirect_to shopping_cart_path
  end

  private

  def lines_exceed_stock
    @virtual_order.map do |line|
      stock = Product.find(line['id']).stock
      current_quantity = line['quantity'].to_i
      stock < current_quantity ? { line:, stock: } : nil
    end
  end
end
