# frozen_string_literal: true

module Customer
  # Class to manage interactions between logged in customer users and order lines of a shopping cart
  class OrderLineFormsController < ApplicationController
    skip_before_action :load_pending_order
    # before_action :authorize_action
    before_action :set_order, only: %i[create update]
    after_action :reset_session, only: %i[create update]
    after_action :set_values, only: %i[new edit]

    # Method to get the form to add a new product (order line) to shopping cart
    # - GET /customer/order_line_forms/new
    def new
      @order_line_form = Forms::OrderLineForm.new(product_id: params[:product_id])
    end

    # Method to add a new product (order line) to shopping cart
    # - POST /customer/order_line_forms
    def create
      Customer::OrderLines::OrderLineCreator.new(order_line_form_params, @order).call
      redirect_to shopping_cart_path, notice: 'Product was successfully added'
    rescue StandardError => e
      flash[:error] = e
      redirect_to new_customer_order_line_form_path(product_id: session[:product_id])
    end

    # Method to get the form to update an order line of the shopping cart
    # - GET /customer/order_line_forms/:id/edit
    def edit
      @order_line_form = Forms::OrderLineForm.new(id: params[:id], product_id: params[:product_id])
    end

    # Method to update an order line of the shopping cart
    # - PATCH /customer/order_line_forms/:id
    def update
      Customer::OrderLines::OrderLineUpdater.new(order_line_form_params, @order).call
      redirect_to shopping_cart_path, notice: 'Product was successfully added'
    rescue StandardError => e
      flash[:error] = e
      redirect_to edit_customer_order_line_form_path(product_id: session[:product_id])
    end

    private

    # Method to set strong paramas for order line form
    def order_line_form_params
      params.require(:forms_order_line_form).permit(:product_id, :price, :quantity, :order_id)
    end

    # Method to authorize actions
    # def authorize_action
    #   authorize OrderLine
    # end

    # Method to create an order, if there is not an order id referenced in the session
    def set_order
      return @order = Order.find(session[:order_id]) if session[:order_id]

      @order = Order.create(user: current_user)
      session[:order_id] = @order.id
    end

    # Method to reset checkout
    def reset_session
      session[:checkout] = nil
      session[:product_id] = nil
      session[:id] = nil
    end

    def set_values
      session[:product_id] = params[:product_id]
      session[:id] = params[:id]
    end
  end
end
