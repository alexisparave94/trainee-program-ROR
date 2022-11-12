# frozen_string_literal: true

module Customer
  # Class to manage interactions between users and shopping cart
  class ShoppingCartController < ApplicationController
    # def index
    #   return @order = Order.find(session[:order_id]) if current_user

    #   @virtual_order = session[:virtual_order]
    # end

    # Method to delete all the lines of a shopping cart
    # - GET /empty_cart
    def empty_cart
      Customer::ShoppingCartEmptier.call(params[:order_id])
      redirect_to shopping_cart_path, notice: 'Shopping cart has been emptied successfully'
    end

    # Method to checkout if there is enough stock for all the products of a shopping cart
    # - GET /checkout
    def checkout
      session[:checkout] = Customer::CheckoutHandler.call(session[:order_id])
      redirect_to shopping_cart_path
    end
  end
end
