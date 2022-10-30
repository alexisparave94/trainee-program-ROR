class OrderLinesController < ApplicationController
  before_action :set_virtual_order, only: %i[create]
  before_action :set_order_line, only: %i[edit update destroy]

  # GET /products/:id_product/order_lines/new
  def new
    @order_line = OrderLine.new
    @product = Product.find(params[:product_id])
    authorize @order_line
  end

  # POST /products/:id_product/order_lines
  def create
    @product = Product.find(params[:product_id])
    add_product
    authorize @order_line
    if @order_line.save
      session[:checkout] = nil
      redirect_to @order_line.order, notice: 'Line was successfully added to shopping cart'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /order_lines/:id/edit
  def edit
    authorize @order_line
  end

  # PATCH /order_lines/:id
  def update
    authorize @order_line
    if @order_line.update(order_line_params)
      session[:checkout] = nil
      redirect_to @order_line.order, notice: 'Line was successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /order_lines/:id
  def destroy
    @order_line.destroy
    authorize @order_line
    session[:checkout] = nil
    redirect_to @order_line.order, notice: 'Line was successfully deleted'
  end

  private

  def order_line_params
    params.require(:order_line).permit(:quantity, :price)
  end

  def set_order_line
    @order_line = OrderLine.find(params[:id])
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

  def set_virtual_order
    @virtual_order = Order.find(session[:order_id])
  rescue ActiveRecord::RecordNotFound
    @virtual_order = Order.create
    session[:order_id] = @virtual_order.id
  end
end
