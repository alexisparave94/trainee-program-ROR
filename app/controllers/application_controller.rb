# frozen_string_literal: true

# Class to manage Application Controller
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_pending_order
  # Rescur for no authorized cations
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Method to persist information of shopping carts
  def set_pending_order
    return unless user_signed_in? && session[:order_id].nil?

    @pending_order = current_user.orders.where(status: 'pending').order(created_at: :DESC).first
    if @pending_order
      session[:order_id] = @pending_order.id
      session[:virtual_order] = nil
      session[:checkout] = nil
    elsif session[:virtual_order]
      @order_lines = save_order_lines
      @order = Order.new(user: current_user)
      @order.order_lines = @order_lines
      @order.total = @order.calculate_total
      # authorize @order
      @order.save
      session[:virtual_order] = nil
      session[:order_id] = @order.id
    end
  end

  protected

  # Method to permit enter more fields to sign uop and sign in with devise gem
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[firt_name last_name])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[firt_name last_name])
  end

  private

  # Method to get message and redirect no authorized actions
  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end

  def save_order_lines
    session[:virtual_order].map do |line|
      OrderLine.create(product_id: line['id'], quantity: line['quantity'], price: line['price'])
    end
  end
end
