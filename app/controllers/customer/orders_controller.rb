class Customer::OrdersController < ApplicationController
  before_action :authenticate_user!, only: %i[create update]

  # POST /customer/orders
  def create
    @order_lines = save_order_lines
    @order = Order.new(user: current_user)
    @order.order_lines = @order_lines
    @order.total = @order.calculate_total
    # authorize @order
    if @order.save
      session[:virtual_order] = nil
      @order.update_products_stock
      redirect_to products_path, notice: 'Thanks for buy'
    else
      render 'order_lines/shopping_cart', status: :unprocessable_entity
    end
  end

  def update
    @order = Order.find(params[:id])
    authorize @order
    if @order.update(
      status: 'completed',
      user: current_user,
      total: @order.calculate_total
    )
      session[:order_id] = nil
      session[:checkout] = nil
      redirect_to products_path, notice: 'Thanks for buy'
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def save_order_lines
    session[:virtual_order].map do |line|
      OrderLine.create(product_id: line['id'], quantity: line['quantity'], price: line['price'])
    end
  end
end
