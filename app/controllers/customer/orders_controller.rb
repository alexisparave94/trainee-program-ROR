# frozen_string_literal: true

module Customer
  # Class to manage Orders Controller of the namespace from customer
  class OrdersController < ApplicationController
    before_action :authenticate_user!, only: %i[index show update]
    before_action :set_order, only: %i[update destroy]
    after_action :update_session, only: %i[update destroy]

    # Method to get index of completed orders of a customer user
    # - GET customer/orders
    def index
      @orders = Customer::OrderLister.call(current_user, 'completed')
      # authorize Order
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
      # authorize @order
      @order = Customer::OrderBuyer.call(@order)
      if @order
        redirect_to products_path, notice: 'Thanks for buy'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # Method to delete an order
    # DELETE /customer/orders/:id
    def destroy
      Customer::OrderDeleter.call(@order)
      redirect_to products_path, notice: 'Shopping cart was successfully deleted'
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def update_session
      session[:order_id] = nil
      session[:checkout] = nil
    end
  end
end
