class OrderLineFormsController < ApplicationController
  before_action :set_product, only: %i[new]
  before_action :set_product_edit, only: %i[edit]
  before_action :set_product_invalid_quantity, only: %i[create update]
  before_action :set_virtual_order, only: %i[create edit update destroy]
  before_action :set_virtual_line, only: %i[edit update]
  
  def new
    @order_line_form = OrderLineForm.new
  end

  def create
    @order_line_form = OrderLineForm.new(order_line_form_params)
    if session[:virtual_order] = @order_line_form.create(@virtual_order, order_line_form_params[:quantity])
      redirect_to shopping_cart_path, notice: 'Line was successfully added to shopping cart'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @order_line_form = OrderLineForm.new(
      product_id: params[:id],
      price: @virtual_line['price'],
      quantity: @virtual_line['quantity']
    )
  end

  def update
    @order_line_form = OrderLineForm.new(order_line_form_params)
    if session[:virtual_order] = @order_line_form.update(@virtual_order)
      redirect_to shopping_cart_path, notice: 'Line was updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_product_edit
    @product = Product.find(params[:id])
  end

  def set_product_invalid_quantity
    @product = Product.find(order_line_form_params[:product_id])
  end

  def order_line_form_params
    params.require(:order_line_form).permit(:product_id, :price, :quantity)
  end

  # Method to create a virtual order to save it in the session storage
  def set_virtual_order
    return @virtual_order = session[:virtual_order] if session[:virtual_order]

    @virtual_order = []
    session[:virtual_order] = @virtual_order
  end

   # Method to set a virtual line
   def set_virtual_line
    @virtual_line = @virtual_order.select { |line| params[:id].to_i == line['id'] }.first
  end
end