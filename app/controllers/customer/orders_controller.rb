# frozen_string_literal: true

class Customer::OrdersController < ApplicationController
  before_action :authenticate_user!, only: %i[update]

  def index
    @orders = current_user.orders.where(status: 'completed').order(created_at: :DESC)
    authorize Order
  end

  def show
    @commentable = Order.find(params[:id])
    @rate = current_user.get_last_rate(@commentable)
    @comment = Comment.new(rate: @rate)
    authorize @commentable
  end

  def update
    @order = Order.find(params[:id])
    authorize @order
    if @order.update(status: 'completed', total: @order.calculate_total)
      @order.update_products_stock
      session[:order_id] = nil
      session[:checkout] = nil
      redirect_to products_path, notice: 'Thanks for buy'
    else
      render :new, status: :unprocessable_entity
    end
  end
end
