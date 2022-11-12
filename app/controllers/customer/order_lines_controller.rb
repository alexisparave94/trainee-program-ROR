# frozen_string_literal: true

module Customer
  # Class to manage interactions between customer users and order lines of a shopping cart
  class OrderLinesController < ApplicationController
    skip_before_action :load_pending_order
    before_action :set_order_line
    before_action :authorize_action
    after_action :reset_checkout

    # Method to delete an order line of the shopping cart
    # - DELETE /customer/order_lines/:id
    def destroy
      Customer::OrderLineDeleter.call(@order_line)
      redirect_to shopping_cart_path, notice: 'Line was successfully deleted'
    end

    private

    # Method to authorize actions
    def authorize_action
      authorize @order_line
    end

    # Method to set a specific order line
    def set_order_line
      @order_line = OrderLine.find(params[:id])
    end

    def reset_checkout
      session[:checkout] = nil
    end
  end
end
