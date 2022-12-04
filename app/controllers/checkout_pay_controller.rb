# frozen_string_literal: true

# Class to manage interactions
class CheckoutPayController < ApplicationController
  # before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_order

  # Method to show shopping cart
  # - POST /checkout_pay
  def create
    # @product = Product.all.first
    session = StripeCheckoutService.call(current_user, @order, root_url, root_url)
    redirect_to session.url, allow_other_host: true
  end

  private

  def set_order
    @order = Order.find(session[:order_id])
  end
end
