# frozen_string_literal: true

# Class to manage interactions
class CheckoutPayController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_order
  after_action :reset_flash

  # Method to show shopping cart
  # - POST /checkout_pay
  def create
    run Operations::Customer::ShoppingCart::Checkout,
        current_user:, order: @order, success_url: root_url, cancel_url: shopping_cart_url do |ctx|
      return redirect_to ctx[:session].url, allow_other_host: true
    end
  #   session = StripeCheckoutFrontService.call(current_user, @order, root_url, shopping_cart_url)
  #   redirect_to session.url, allow_other_host: true
  # rescue StandardError => e
    flash[:alert] = 'Please check the current stock of the products'
    redirect_to shopping_cart_path
  end

  private

  def set_order
    @order = Order.find(session[:order_id])
  end

  def reset_flash
    flash[:notice] = nil
  end
end
