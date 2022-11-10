class Customer::OrderLineFormsController < ApplicationController
  skip_before_action :load_pending_order
  before_action :set_product, only: %i[new]
  before_action :set_order, only: %i[create]
  before_action :set_product_invalid_quantity, only: %i[create update]
  before_action :set_order_line_form, only: %i[edit]
  before_action :set_product_edit, only: %i[edit]

  def new
    @order_line_form = OrderLineForm.new
  end

  def create
    @order_line_form = OrderLineForm.new(order_line_form_params)
    if @order_line_form.create(@order)
      redirect_to shopping_cart_path, notice: 'Line was successfully added to shopping cart'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    pp @order_line_form = OrderLineForm.new(order_line_form_params.merge(id: params[:id]))
    if @order_line_form.update
      redirect_to shopping_cart_path, notice: 'Line was updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_order_line_form
    @order_line_form = OrderLineForm.new(id: params[:id])
  end

  def set_product_invalid_quantity
    @product = Product.find(order_line_form_params[:product_id])
  end

  def order_line_form_params
    params.require(:order_line_form).permit(:product_id, :price, :quantity, :order_id)
  end

  # Method to create an order, if there is not an order id referenced in the session
  def set_order
    return @order = Order.find(session[:order_id]) if session[:order_id]

    @order = Order.create(user: current_user)
    session[:order_id] = @order.id
  end

  def set_product_edit
    @product = Product.find(@order_line_form.product_id)
  end

  # def set_product_invalid_quantity
  #   @product = Product.find(order_line_form_params[:product_id])
  # end

  # # Method to create a virtual order to save it in the session storage
  # def set_virtual_order
  #   return @virtual_order = session[:virtual_order] if session[:virtual_order]

  #   @virtual_order = []
  #   session[:virtual_order] = @virtual_order
  # end

  #  # Method to set a virtual line
  #  def set_virtual_line
  #   @virtual_line = @virtual_order.select { |line| params[:id].to_i == line['id'] }.first
  # end
end