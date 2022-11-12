# frozen_string_literal: true

# Class to manage interactions between no logged in users and virtula order lines of a shopping cart
class OrderLineFormsController < ApplicationController
  before_action :set_virtual_order, only: %i[create edit update]
  after_action :update_session, only: %i[create update]

  # Method to get the form to add a new product (order line) to the shopping cart
  # - GET /order_line_forms/new
  def new
    @order_line_form = Forms::OrderLineForm.new(product_id: params[:product_id])
  end

  # Method to add a new product (order line) to the shopping cart
  # - POST /order_line_forms
  def create
    @order_line_form = Forms::OrderLineForm.new(order_line_form_params)
    if @order_line_form.virtual_create(@virtual_order, order_line_form_params[:quantity])
      redirect_to shopping_cart_path, notice: 'Line was successfully added to shopping cart'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # Method to get the form to update an order line of the shopping cart
  # - GET /order_line_forms/:id/edit
  def edit
    @order_line_form = Forms::OrderLineForm.new(
      product_id: params[:id],
      price: params[:price],
      quantity: params[:quantity]
    )
  end

  # Method to update an order line of the shopping cart
  # - PATCH /order_line_forms/:id
  def update
    @order_line_form = Forms::OrderLineForm.new(order_line_form_params)
    if @order_line_form.virtual_update(@virtual_order)
      redirect_to shopping_cart_path, notice: 'Line was updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  # Method to set strong paramas for order line form
  def order_line_form_params
    params.require(:forms_order_line_form).permit(:product_id, :price, :quantity)
  end

  # Method to create a virtual order to save it in the session storage
  def set_virtual_order
    return @virtual_order = session[:virtual_order] if session[:virtual_order]

    @virtual_order = []
    session[:virtual_order] = @virtual_order
  end

  # Method to update values of session
  def update_session
    session[:checkout] = nil
    session[:virtual_order] = @virtual_order
  end
end
