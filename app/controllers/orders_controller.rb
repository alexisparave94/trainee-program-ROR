class OrdersController < ApplicationController
  before_action :set_card

  def create
    @order = Order.new(status: 'completed', customer_id: 1)
    @order.add_lines_from_cart(@cart)
    @order.total = @cart.calculate_total
    if @order.save
      Cart.destroy(session[:cart_id])
      session[:cart_id] = nil
      redirect_to products_path, notice: 'Thanks for buy'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def set_card
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end
end
