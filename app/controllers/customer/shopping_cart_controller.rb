# frozen_string_literal: true

module Customer
  # Class to manage interactions between customer users and shopping cart
  class ShoppingCartController < ApplicationController
    # Method to delete all the lines of a shopping cart
    # - GET /customer/empty_cart
    def empty_cart
      Customer::ShoppingCartEmptier.call(params[:order_id])
      redirect_to shopping_cart_path, notice: 'Shopping cart has been emptied successfully'
    rescue StandardError => e
      flash[:error] = e
      session[:order_id] = nil
      redirect_to products_path
    end

    # Method to checkout if there is enough stock for all the products of a shopping cart
    # - GET /customer/checkout
    def checkout
      session[:checkout] = Customer::CheckoutHandler.call(session[:order_id])
      redirect_to shopping_cart_path
    rescue StandardError => e
      flash[:error] = e
      session[:order_id] = nil
      redirect_to products_path
    end
  end
end
