# frozen_string_literal: true

module Customer
  # Class to manage Orders Controller of the namespace from customer
  class OrdersController < ApplicationController
    before_action :authenticate_user!, only: %i[update]

    # Method to get index of completed orders of a customer user
    # - GET customer/orders
    def index
      @orders = current_user.orders.where(status: 'completed').order(created_at: :DESC)
      authorize Order
    end

    # Method to get show of an order of a customer user
    # - GET customer/orders/:id
    def show
      @commentable = Order.find(params[:id])
      @rate = current_user.get_last_rate(@commentable)
      @comment = Comment.new(rate: @rate)
      authorize @commentable
    end

    # Method to update an order to status completed of a customer user
    # - PATCH customer/orders/:id
    def update
      @order = Order.find(params[:id])
      authorize @order
      if @order.completed?
        redirect_purchase_completed
      elsif @order.update(status: 'completed', total: @order.calculate_total)
        @order.update_products_stock
        session[:order_id] = nil
        session[:checkout] = nil
        redirect_to products_path, notice: 'Thanks for buy'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def redirect_purchase_completed
      redirect_to products_path, notice: 'Have already made this purchase'
    end
  end
end
