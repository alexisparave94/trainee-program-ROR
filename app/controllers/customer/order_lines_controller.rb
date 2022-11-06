# frozen_string_literal: true

module Customer
  # Class to manage interactions between customer users and order lines of a shopping cart
  class OrderLinesController < ApplicationController
    skip_before_action :load_pending_order
    before_action :set_order_line, only: %i[edit update destroy]

    # Method to get the form to add a new product (order line) to the shopping cart
    # - GET /customer/order_lines/new
    def new
      @product = Product.find(params[:product_id])
      @order_line = OrderLine.new
      authorize @order_line
    end

    # Method to add a new product (order line) to the shopping cart
    # - POST /customer/order_lines
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

    # Method to get the form to update an order line of the shopping cart
    # - GET /customer/order_lines/:id/edit
    def edit
      @product = @order_line.product
      authorize @order_line
    end

    # Method to update an order line of the shopping cart
    # - PATCH /customer/order_lines/:id
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

    # Method to delete an order line of the shopping cart
    # - DELETE /customer/order_lines/:id
    def destroy
      authorize @order_line
      @order_line.destroy
      session[:checkout] = nil
      redirect_to shopping_cart_path, notice: 'Line was successfully deleted'
    end

    private

    # Method to set strong paramas for order line
    def order_line_params
      params.require(:order_line).permit(:quantity, :price, :product_id, :order_id)
    end

    # Method to set a specific order line
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

    # Method to create an order, if there is not an order id referenced in the session
    def set_order
      return @order = Order.find(session[:order_id]) if session[:order_id]

      @order = Order.create(user: current_user)
      session[:order_id] = @order.id
    end
  end
end
