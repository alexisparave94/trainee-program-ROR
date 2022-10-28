class OrderLinesController < ApplicationController
  before_action :set_virtual_order, only: %i[create edit]

  # GET /products/:id_product/order_lines/new
  def new
    @order_line = OrderLine.new
    @product = Product.find(params[:product_id])
  end

  # POST /products/:id_product/order_lines
  def create
    @product = Product.find(params[:product_id])
    add_product
    if @order_line.save
      redirect_to show_cart_path, notice: 'Line was successfully added to shopping cart'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @order_line = OrderLine.find(params[:id])
  end

  def update
    @order_line = OrderLine.find(params[:id])
    if @order_line.update(order_line_params)
      redirect_to show_cart_path, notice: 'Line was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
    # @virtual_order = session[:virtual_order]
    # @current_virtual_line = find_virtual_line(@virtual_order, params[:id]).first['order_line']
    # @current_virtual_line['quantity'] = params[:quantity].to_i
    # session[:virtual_order] = @virtual_order
    # redirect_to show_cart_path, notice: 'Line was successfully updated'
    # if @order_line.update(order_line_params)
    #   redirect_to @order_line.cart, notice: 'Shopping cart line was successfully updated'
    # else
    #   render :edit, status: :unprocessable_entity
    # end
  end

  def destroy
    @virtual_order = session[:virtual_order]
    @virtual_order.reject! { |detail| detail['order_line']['product_id'] == params[:id].to_i }
    session[:virtual_order] = @virtual_order
    redirect_to show_cart_path, notice: 'Line was successfully deleted'
  end

  private

  def order_line_params
    params.require(:order_line).permit(:quantity, :price)
  end

  def add_product
    @order_line = @virtual_order.order_lines.find_by(product_id: @product.id)
    if @order_line.nil?
      @order_line = OrderLine.new(order_line_params)
      @order_line.product = @product
      @order_line.order = @virtual_order
    else
      @order_line.quantity += order_line_params[:quantity].to_i
    end
  end

  def find_virtual_line(virtual_order, id)
    virtual_order.select { |detail| detail['order_line']['product_id'] == id.to_i }
  end

  def set_virtual_order
    @virtual_order = Order.find(session[:order_id])
  rescue ActiveRecord::RecordNotFound
    @virtual_order = Order.create
    session[:order_id] = @virtual_order.id
  end
end
