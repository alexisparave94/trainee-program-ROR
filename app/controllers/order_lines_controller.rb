class OrderLinesController < ApplicationController
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
    redirect_to show_cart_path, notice: 'Line was successfully added'
    # @order_line = @cart.add_product(order_line_params)
    # if @order_line.save
    #   redirect_to @order_line.cart, notice: 'Line was successfully added to cart'
    # else
    #   render :new, status: :unprocessable_entity
    # end
  end

  def edit
    @virtual_order = session[:virtual_order]
    @current_virtual_line = find_virtual_line(@virtual_order, params[:id]).first['order_line']
    @id = params[:id]
  end

  def update
    @virtual_order = session[:virtual_order]
    @current_virtual_line = find_virtual_line(@virtual_order, params[:id]).first['order_line']
    @current_virtual_line['quantity'] = params[:quantity].to_i
    session[:virtual_order] = @virtual_order
    redirect_to show_cart_path, notice: 'Line was successfully updated'
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
    params.require(:order_line).permit(:product_id, :quantity, :price)
  end

  def add_virtual_line(detail)
    @virtual_order = session[:virtual_order] if session[:virtual_order]
    @current_virtual_line = find_virtual_line(@virtual_order, order_line_params[:product_id]).first
    if @current_virtual_line
      @current_virtual_line['order_line']['quantity'] += order_line_params[:quantity].to_i
    else
      @virtual_order << detail
    end
    session[:virtual_order] = @virtual_order
  end

  def find_virtual_line(virtual_order, id)
    virtual_order.select { |detail| detail['order_line']['product_id'] == id.to_i }
  end
end
