class OrderLinesController < ApplicationController
  before_action :set_card, only: %i[create]
  before_action :set_order_line, only: %i[edit update destroy]

  def new
    @order_line = OrderLine.new
    @product = Product.find(params[:product_id])
  end

  def create
    @order_line = @cart.add_product(order_line_params)
    if @order_line.save
      redirect_to @order_line.cart, notice: 'Line was successfully added to cart'
    else
      render :new, status: :unprocessable_entity
    end
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

  def set_card
    @cart = Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
    @cart = Cart.create
    session[:cart_id] = @cart.id
  end

  def set_order_line
    @order_line = OrderLine.find(params[:id])
  end
end
