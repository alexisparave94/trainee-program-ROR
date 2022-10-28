class Customer::OrdersController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  def create
    @virtual_order = session[:virtual_order]
    @order = Order.new(status: 'completed', user: current_user)
    @order.add_lines_from_cart(@virtual_order)
    @order.total = @order.calculate_total
    if @order.save
      session[:virtual_order] = []
      session[:checkout] = nil
      redirect_to products_path, notice: 'Thanks for buy'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy; end
end
