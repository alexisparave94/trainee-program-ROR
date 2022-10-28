class OrdersController < ApplicationController
  def show_cart
    @lines_exceed_stock = nil
    @virtual_order = session[:virtual_order]
  end

  def create
    @order = Order.new(status: 'completed', customer_id: 1)
    @order.add_lines_from_cart(@cart)
    @order.total = @cart.calculate_total
    # if @order.save
    #   Cart.destroy(session[:cart_id])
    #   session[:cart_id] = nil
    #   redirect_to products_path, notice: 'Thanks for buy'
    # else
    #   render :new, status: :unprocessable_entity
    # end
  end

  def destroy
    session[:virtual_order] = []
    redirect_to show_cart_path, notice: 'Cart has been emptied'
  end

  def checkout
    @virtual_order = session[:virtual_order]
    @lines_exceed_stock = @virtual_order.map do |detail|
      stock = Product.find(detail['product']['id']).stock
      current_quantity = detail['order_line']['quantity']
      stock < current_quantity ? { product: detail['product'], stock: } : nil
    end

    @lines_exceed_stock.compact!
    render :show_cart
  end
end
