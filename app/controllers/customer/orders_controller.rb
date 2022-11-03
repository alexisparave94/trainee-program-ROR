# frozen_string_literal: true

module Customer
  class OrdersController < ApplicationController
    before_action :authenticate_user!, only: %i[update]

    def update
      @order = Order.find(params[:id])
      # authorize @order
      if @order.update(status: 'completed', total: @order.calculate_total)
        @order.update_products_stock
        session[:order_id] = nil
        session[:checkout] = nil
        redirect_to products_path, notice: 'Thanks for buy'
      else
        render :new, status: :unprocessable_entity
      end
    end
  end
end
