# frozen_string_literal: true

# Class to manage interactions between no logged in users and shopping cart (except index this metho is for all users)
class ShoppingCartController < ApplicationController
  # Method to show shopping cart
  # - GET /shopping_cart
  def index
    run Operations::ShoppingCart::Index,
        params:, current_user:,
        order_id: session[:order_id], virtual_order: session[:virtual_order] do |ctx|
      @order = ctx[:order]
      @virtual_order = ctx[:virtual_order]
      return
    end
    flash[:alert] = 'The purchase has been completed'
    session[:order_id] = nil
    redirect_to products_path

  #   @order, @virtual_order = OrdersSetter.call(current_user, session[:order_id], session[:virtual_order])
  # rescue StandardError => e
  #   flash[:alert] = e
  #   session[:order_id] = nil
  #   redirect_to products_path
  end

  # Method to delete all the lines of a shopping cart
  # - GET /empty_cart
  def empty_cart
    # session[:virtual_order] = ShoppingCartEmptier.call
    session[:virtual_order] = nil
    redirect_to shopping_cart_path, notice: 'Shopping cart has been emptied successfully'
  end

  # Method to checkout if there is enough stock for all the products of a shopping cart
  # - GET /checkout
  # def checkout
  #   session[:checkout] = CheckoutHandler.call(session[:virtual_order])
  #   redirect_to shopping_cart_path
  # end
end
