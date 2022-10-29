class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?
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

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[firt_name last_name])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[firt_name last_name])
  end
end
