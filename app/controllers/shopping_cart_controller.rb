# frozen_string_literal: true

# Class to manage interactions between users and shopping cart
class ShoppingCartController < ApplicationController
  def index
    return @order = Order.find(session[:order_id]) if current_user

    @virtual_order = session[:virtual_order]
  end

  # Method to delete all the lines of a shopping cart
  # - GET /empty_cart
  def empty_cart
    session[:virtual_order] = ShoppingCartEmptier.call
    redirect_to shopping_cart_path, notice: 'Shopping cart has been emptied successfully'
  end

  # Method to checkout if there is enough stock for all the products of a shopping cart
  # - GET /checkout
  def checkout
    if current_user
      @order = Order.find(session[:order_id])
      session[:checkout] = @order.lines_exceed_stock.compact
    else
      # @virtual_order = session[:virtual_order]
      session[:checkout] = CheckoutHandler.call(session[:virtual_order])
    end
    redirect_to shopping_cart_path
  end

  private

  # Method to look for products that exceed the stock of an order
  def lines_exceed_stock
    @virtual_order.map do |line|
      stock = Product.find(line['id']).stock
      current_quantity = line['quantity'].to_i
      stock < current_quantity ? { line:, stock: } : nil
    end
  end
end
