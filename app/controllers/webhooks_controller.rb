# frozen_string_literal: true

# Class to manage interactions
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  after_action :update_session, only: %i[checkout_session_completed]

  def checkout_session_completed
    status = CheckoutSessionCompletedService.call(request)
    render json: { message: 'success' }, status:
  end

  def payment_failed
    status = PaymentFailedService.call(request)
    render json: { message: 'payment failed' }, status:
  end

  # Method to update values of session storage
  def update_session
    session[:order_id] = nil
    session[:checkout] = nil
  end
end
