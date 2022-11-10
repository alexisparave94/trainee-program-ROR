# frozen_string_literal: true

# Class to manage interactions between no logged in users and order lines of a shopping cart
class OrderLinesController < ApplicationController
  before_action :set_virtual_order, only: %i[create edit update destroy]
  after_action :virtual_order_empty, only: %i[destroy]
  after_action :reset_checkout, only: %i[destroy]

  # Method to get the form to add a new product (order line) to the shopping cart
  # - GET /order_lines/new
  def new
    @order_line = OrderLine.new
    @product = Product.find(params[:product_id])
  end

  # Method to add a new product (order line) to the shopping cart
  # - POST /order_lines
  def create
    @product = Product.find(order_line_params[:product_id])
    @order_line = OrderLine.new(order_line_params)
    if @order_line.valid?
      add_product
      session[:checkout] = nil
      redirect_to shopping_cart_path, notice: 'Line was successfully added to shopping'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Method to get the form to update an order line of the shopping cart
  # - GET /order_lines/:id/editt
  def edit
    set_virtual_line
    @order_line = OrderLine.new(
      product_id: params[:id],
      price: @virtual_line['price'],
      quantity: @virtual_line['quantity']
    )
    @product = Product.find(params[:id])
  end

  # Method to update an order line of the shopping cart
  # - PATCH /order_lines/:id
  def update
    @product = Product.find(order_line_params[:product_id])
    @order_line = OrderLine.new(order_line_params)
    if @order_line.valid?
      set_virtual_line
      set_quantity_for_virtual_line
      session[:virtual_order] = @virtual_order
      session[:checkout] = nil
      redirect_to shopping_cart_path, notice: 'Line was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # Method to delete an order line of the shopping cart
  # - DELETE /order_lines/:id
  def destroy
    @virtual_order = OrderLineDeleter.call(params[:id], @virtual_order)
    redirect_to shopping_cart_path, notice: 'Line was successfully deleted'
  end

  private

  def virtual_order_empty
    session[:virtual_order] = @virtual_order.empty? ? nil : @virtual_order
  end

  def reset_checkout
    session[:checkout] = nil
  end

  # Method to set strong paramas for order line
  def order_line_params
    params.require(:order_line).permit(:quantity, :price, :product_id)
  end

  # Method to add a new line or if the line exists only sum quantities
  def add_product
    look_for_virtual_line_in_virtual_order
    if @virtual_line
      @virtual_line['quantity'] += order_line_params[:quantity].to_i
    else
      @virtual_order << { id: @product.id, name: @product.name, price: @product.price.to_f,
                          quantity: order_line_params[:quantity].to_i }
    end
    session[:virtual_order] = @virtual_order
  end

  # Method to create a virtual order to save it in the session storage
  def set_virtual_order
    return @virtual_order = session[:virtual_order] if session[:virtual_order]

    @virtual_order = []
    session[:virtual_order] = @virtual_order
  end

  # Method to look for a product in a virtual order
  def look_for_virtual_line_in_virtual_order
    @virtual_line = @virtual_order.select { |line| line['id'] == order_line_params[:product_id].to_i }.first
  end

  # Method to set a virtual line
  def set_virtual_line
    @virtual_line = @virtual_order.select { |line| params[:id].to_i == line['id'] }.first
  end

  # Method to set the quantity of a virtual line
  def set_quantity_for_virtual_line
    @virtual_line['quantity'] = order_line_params[:quantity].to_i
  end
end
