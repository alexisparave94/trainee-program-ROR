class OrderLinesController < ApplicationController
  before_action :set_virtual_order, only: %i[create edit update destroy]

  # GET /products/:id_product/order_lines/new
  def new
    @order_line = OrderLine.new
    @product = Product.find(params[:product_id])
    # authorize @order_line
  end

  # POST /products/:id_product/order_lines
  def create
    @product = Product.find(order_line_params[:product_id])
    @order_line = OrderLine.new(order_line_params)
    if @order_line.valid?
      add_product
      # authorize @order_line
      session[:checkout] = nil
      redirect_to shopping_cart_path, notice: 'Line was successfully added to shopping'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /order_lines/:id/edit
  def edit
    @line = @virtual_order.select { |line| params[:id].to_i == line['id'] }.first
    @order_line = OrderLine.new(
      product_id: params[:id],
      price: @line['price'],
      quantity: @line['quantity']
    )
    @product = Product.find(params[:id])
    # authorize @order_line
  end

  # PATCH /order_lines/:id
  def update
    # authorize @order_line
    @product = Product.find(order_line_params[:product_id])
    @order_line = OrderLine.new(order_line_params)
    if @order_line.valid?
      @line = @virtual_order.select { |line| params[:id].to_i == line['id'] }.first
      @line['quantity'] = order_line_params[:quantity].to_i
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

  def shopping_cart
    return @order = Order.find(session[:order_id]) if current_user

    @virtual_order = session[:virtual_order]
  end

  private

  def order_line_params
    params.require(:order_line).permit(:quantity, :price, :product_id)
  end

  # Method to add a new line or if the line exists only sum quantities
  def add_product
    @virtual_line = @virtual_order.select { |line| line['id'] == order_line_params[:product_id].to_i }.first
    if @virtual_line
      puts 'Find line'
      @virtual_line['quantity'] += order_line_params[:quantity].to_i
    else
      puts 'Not find'
      @virtual_order << { id: @product.id, name: @product.name, price: @product.price.to_f, quantity: order_line_params[:quantity].to_i }
    end
    session[:virtual_order] = @virtual_order
  end

  # Method to create a virtual order to save it in the session storage
  def set_virtual_order
    return @virtual_order = session[:virtual_order] if session[:virtual_order]

    @virtual_order = []
    session[:virtual_order] = @virtual_order
  end
end
