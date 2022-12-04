# frozen_string_literal: true

# Class to manage interactions
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  after_action :update_session

  def create
    StripeWebhookService.call(request)
    render json: { message: 'success' }
  end

  # Method to update values of session storage
  def update_session
    session[:order_id] = nil
    session[:checkout] = nil
  end
end
