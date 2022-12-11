# frozen_string_literal: true

# Class to manage interactions
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  after_action :update_session, only: %i[checkout_session_completed]

  def checkout_session_completed
    run Operations::Customer::StripeWebhooks::CheckoutSessionCompleted,
        request: do |ctx|
      render json: { message: 'success' }, status: ctx[:status]
    end

    # status = CheckoutSessionCompletedService.call(request, ENV.fetch('CHECKOUT_SESSION_COMPLETE_KEY', nil))
    # render json: { message: 'success' }, status:
  end

  def payment_failed
    run Operations::Customer::StripeWebhooks::PaymentFailed,
        request: do |ctx|
      render json: { message: 'payment failed' }, status: ctx[:status]
    end
    # status = PaymentFailedService.call(request, ENV.fetch('PAYMENT_INTENT_FAILED_KEY', nil))
    # render json: { message: 'payment failed' }, status:
  end

  # Method to update values of session storage
  def update_session
    session[:order_id] = nil
    session[:checkout] = nil
  end
end
