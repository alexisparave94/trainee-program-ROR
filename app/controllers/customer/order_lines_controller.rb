class Customer::OrderLinesController < ApplicationController
  skip_before_action :set_pending_order

  # POST /customer/orders
  def new
    @product = Product.find(params[:product_id])
    @order_line = OrderLine.new
  end

  def create
    set_order
    add_product
    @order_line.order = @order
    if @order_line.save
      session[:checkout] = nil
      redirect_to shopping_cart_path, notice: 'Line was successfully added'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @order_line = OrderLine.find(params[:id])
    @product = @order_line.product
  end

  def update
    @order_line = OrderLine.find(params[:id])
    if @order_line.update(order_line_params)
      session[:checkout] = nil
      redirect_to shopping_cart_path, notice: 'Line was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order_line = OrderLine.find(params[:id])
    @order_line.destroy
    session[:checkout] = nil
    redirect_to shopping_cart_path, notice: 'Line was successfully deleted'
  end

  private

  def order_line_params
    params.require(:order_line).permit(:quantity, :price, :product_id, :order_id)
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