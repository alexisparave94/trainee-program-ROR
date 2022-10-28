class OrderLinesController < ApplicationController
  # before_action :set_card, only: %i[create]
  before_action :set_order_line, only: %i[edit update destroy]

  def new
    @order_line = OrderLine.new
    @product = Product.find(params[:product_id])
  end

  def create
    @order_line = OrderLine.new(order_line_params)
    @product = Product.find(order_line_params[:product_id])
    @virtual_order = []
    detail = { order_line: @order_line, product: @product }
    add_virtual_line(detail)
    # @order_line = @cart.add_product(order_line_params)
    # if @order_line.save
    #   redirect_to @order_line.cart, notice: 'Line was successfully added to cart'
    # else
    #   render :new, status: :unprocessable_entity
    # end
  end

  def edit; end

  def update
    if @order_line.update(order_line_params)
      redirect_to @order_line.cart, notice: 'Shopping cart line was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order_line.destroy
    redirect_to @order_line.cart, notice: 'Line was successfully deleted'
  end

  private

  def order_line_params
    params.require(:order_line).permit(:product_id, :quantity, :price)
  end

  def add_virtual_line(detail)
    @virtual_order = session[:virtual_order] if session[:virtual_order]
    @virtual_order << detail
    session[:virtual_order] = @virtual_order
  end

  def set_order_line
    @order_line = OrderLine.find(params[:id])
  end
end
