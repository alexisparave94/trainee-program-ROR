# frozen_string_literal: true

module Customer
  # Class to manage Products Controller of the namespace from customer
  class OrderLinesController < ApplicationController
    skip_before_action :load_pending_order
    before_action :set_order_line, only: %i[edit update destroy]

    # POST /customer/orders
    def new
      @product = Product.find(params[:product_id])
      @order_line = OrderLine.new
      authorize @order_line
    end

    def create
      set_order
      add_product
      @product = @order_line.product
      @order_line.order = @order
      authorize @order_line
      if @order_line.save
        session[:checkout] = nil
        redirect_to shopping_cart_path, notice: 'Line was successfully added'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @product = @order_line.product
      authorize @order_line
    end

    def update
      @product = @order_line.product
      authorize @order_line
      if @order_line.update(order_line_params)
        session[:checkout] = nil
        redirect_to shopping_cart_path, notice: 'Line was successfully updated'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @order_line
      @order_line.destroy
      session[:checkout] = nil
      redirect_to shopping_cart_path, notice: 'Line was successfully deleted'
    end

    private

    def order_line_params
      params.require(:order_line).permit(:quantity, :price, :product_id, :order_id)
    end

    def set_order_line
      @order_line = OrderLine.find(params[:id])
    end

    # Method to add a new order line or if the line exists only sum quantities
    def add_product
      @order_line = @order.order_lines.find_by(product_id: order_line_params[:product_id])
      if @order_line.nil?
        @order_line = OrderLine.new(order_line_params)
      else
        @order_line.quantity += order_line_params[:quantity].to_i
      end
    end

    # Method to create an order if there is not an order id referenced in the session storage
    def set_order
      return @order = Order.find(session[:order_id]) if session[:order_id]

      @order = Order.create(user: current_user)
      session[:order_id] = @order.id
    end
  end
end
