class Customer::OrdersController < ApplicationController
  before_action :authenticate_user!, only: %i[update]

  def update
    @order = Order.find(params[:id])
    if @order.update(
      status: 'completed',
      user: current_user,
      total: @order.calculate_total
    )
      session[:order_id] = nil
      session[:checkout] = nil
      redirect_to products_path, notice: 'Thanks for buy'
    else
      render :new, status: :unprocessable_entity
    end
  end
end
