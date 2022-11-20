# frozen_string_literal: true

# Class to manage interactions between no logged in users and virtula order lines of a shopping cart
class OrderLineFormsController < ApplicationController
  before_action :set_virtual_order, only: %i[create edit update]
  after_action :update_session, only: %i[create update]
  after_action :set_values, only: %i[new edit]

  # Method to get the form to add a new product (order line) to the shopping cart
  # - GET /order_line_forms/new
  def new
    @order_line_form = Customer::OrderLines::NewFormGetter.call(product_id: params[:product_id])
  end

  # Method to add a new product (order line) to the shopping cart
  # - POST /order_line_forms
  def create
    VirtualOrderLineCreator.new(order_line_form_params, @virtual_order).call
    redirect_to shopping_cart_path, notice: 'Product was successfully added'
  rescue StandardError => e
    flash[:error] = e
    redirect_to new_order_line_form_path(product_id: session[:product_id])
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
    VirtualOrderLineUpdater.call(order_line_form_params, @virtual_order)
    redirect_to shopping_cart_path, notice: 'Quantity was successfully updated'
  rescue StandardError => e
    flash[:error] = e
    redirect_to edit_order_line_form_path(id: session[:product_id],
                                          price: session[:price], quantity: session[:quantity])
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
    session[:product_id] = nil
  end

  def set_values
    session[:product_id] = params[:product_id] || params[:id]
    session[:price] = params[:price]
    session[:quantity] = params[:quantity]
  end
end
