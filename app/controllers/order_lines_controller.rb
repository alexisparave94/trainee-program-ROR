# frozen_string_literal: true

# Class to manage interactions between no logged in users and order lines of a shopping cart
class OrderLinesController < ApplicationController
  before_action :set_virtual_order, only: %i[destroy]
  after_action :virtual_order_empty, only: %i[destroy]
  after_action :reset_checkout, only: %i[destroy]

  # Method to delete an order line of the shopping cart
  # - DELETE /order_lines/:id
  def destroy
    @virtual_order = OrderLineDeleter.call(params[:id], @virtual_order)
    redirect_to shopping_cart_path, notice: 'Line was successfully deleted'
  end

  private

  # Method to validate an empty virtual order
  def virtual_order_empty
    session[:virtual_order] = @virtual_order.empty? ? nil : @virtual_order
  end

  # Method to reset checkout
  def reset_checkout
    session[:checkout] = nil
  end

  # Method to create a virtual order to save it in the session storage
  def set_virtual_order
    return @virtual_order = session[:virtual_order] if session[:virtual_order]

    @virtual_order = []
    session[:virtual_order] = @virtual_order
  end
end
