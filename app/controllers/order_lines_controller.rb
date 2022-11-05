# frozen_string_literal: true

# Class to manage Order Lines Controller
class OrderLinesController < ApplicationController
  before_action :set_virtual_order, only: %i[create edit update destroy]

  # GET /products/:id_product/order_lines/new
  def new
    @order_line = OrderLine.new
    @product = Product.find(params[:product_id])
  end

  # POST /products/:id_product/order_lines
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

  # GET /order_lines/:id/edit
  def edit
    set_virtual_line
    @order_line = OrderLine.new(
      product_id: params[:id],
      price: @virtual_line['price'],
      quantity: @virtual_line['quantity']
    )
    @product = Product.find(params[:id])
  end

  # PATCH /order_lines/:id
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

  # DELETE /order_lines/:id
  def destroy
    @virtual_order.reject! { |line| line['id'] == params[:id].to_i }
    session[:virtual_order] = @virtual_order.empty? ? nil : @virtual_order
    session[:checkout] = nil
    redirect_to shopping_cart_path, notice: 'Line was successfully deleted'
  end

  private

  def order_line_params
    params.require(:order_line).permit(:quantity, :price, :product_id)
  end

  # Method to add a new line or if the line exists only sum quantities
  def add_product
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

  def look_for_virtual_line_in_virtuakl_order
    @virtual_line = @virtual_order.select { |line| line['id'] == order_line_params[:product_id].to_i }.first
  end

  def set_virtual_line
    @virtual_line = @virtual_order.select { |line| params[:id].to_i == line['id'] }.first
  end

  def set_quantity_for_virtual_line
    @virtual_line['quantity'] = order_line_params[:quantity].to_i
  end
end
