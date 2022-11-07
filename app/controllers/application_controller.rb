# frozen_string_literal: true

# Class to manage Application Controller
class ApplicationController < ActionController::Base
  include Pundit::Authorization
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :load_pending_order
  # Rescur for no authorized cations
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  # Method to persist information of shopping carts
  def load_pending_order
    return unless load_pending_order?

    look_for_the_last_pending_order
    if @pending_order
      session[:checkout] = nil
      save_order_id_in_session(@pending_order.id)
    elsif session[:virtual_order]
      save_order_lines
      create_new_pending_order
      save_order_id_in_session(@pending_order.id)
    end
    session[:virtual_order] = nil
  end

  protected

  # Method to permit enter more fields to sign up with devise gem
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name])
  end

  private

  # Method to get message and redirect no authorized actions
  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end

  # Method to pass virtual order lines from session to order lines in database
  def save_order_lines
    @order_lines = session[:virtual_order].map do |line|
      OrderLine.create(product_id: line['id'], quantity: line['quantity'], price: line['price'])
    end
  end

  # Method to load the last pending order of an user
  def look_for_the_last_pending_order
    @pending_order = current_user.orders.where(status: 'pending').order(created_at: :DESC).first
  end

  # Method to create a new pending order
  def create_new_pending_order
    @pending_order = Order.new(user: current_user)
    @pending_order.order_lines = @order_lines
    @pending_order.total = @pending_order.calculate_total
    @pending_order.save
  end

  # Method to save order id in session
  def save_order_id_in_session(id)
    session[:order_id] = id
  end

  # Method to validate if it should load a pending order
  def load_pending_order?
    user_signed_in? && session[:order_id].nil?
  end
end
