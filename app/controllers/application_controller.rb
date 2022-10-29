class ApplicationController < ActionController::Base
  before_action :load_cart

  def load_cart
    return unless user_signed_in?

    @pending_order = current_user.orders.where(status: 'pending').take
    if @pending_order
      session[:order_id] = @pending_order.id
    elsif session[:order_id]
      @order = Order.find(session[:order_id])
      @order.update(
        status: 'pending',
        user: current_user,
        total: @order.calculate_total
      )
    end
  end
end
