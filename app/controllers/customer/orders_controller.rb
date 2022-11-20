# frozen_string_literal: true

module Customer
  # Class to manage Orders Controller of the namespace from customer
  class OrdersController < ApplicationController
    before_action :authenticate_user!, only: %i[index show update]
    before_action :set_order, only: %i[show update destroy]
    before_action :authorize_action, only: %i[show update destroy]
    after_action :update_session, only: %i[update destroy]

    # Method to get index of completed orders of a customer user
    # - GET customer/orders
    def index
      authorize Order
      @orders = Customer::OrderLister.call(current_user, 'completed')
    end

    # Method to get show of an order of a customer user
    # - GET customer/orders/:id
    def show
      # @comment_order_form = Forms::CommentOrderForm.new({ order_id: params[:id] }, current_user)
      @comment_order_form = Customer::OrderShower.call({ order_id: params[:id] }, current_user)
      # authorize @commentable
    end

    # Method to update an order to status completed of a customer user
    # - PATCH customer/orders/:id
    def update
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
    rescue StandardError => e
      flash[:error] = e
      session[:order_id] = nil
      redirect_to products_path
    end

    private

    # Method to set order
    def set_order
      @order = Order.find(params[:id])
    end

    # Method to update values of session storage
    def update_session
      session[:order_id] = nil
      session[:checkout] = nil
    end

    # Method to autorize actions
    def authorize_action
      authorize @order
    end
  end
end
