class OrderLinesController < ApplicationController
  before_action :set_card, only: %i[create]

  def new
    @order_line = OrderLine.new
    @product = Product.find(params[:product_id])
  end

  def create
    @order_line = @cart.add_product(order_line_params)
    if @order_line.save
      redirect_to @order_line.cart, notice: 'Product was successfully added to cart'
    else
      render :new, status: :unprocessable_entity
    end
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
end
