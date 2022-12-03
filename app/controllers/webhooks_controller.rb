# frozen_string_literal: true

# Class to manage interactions
class WebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  # skip_before_action :authenticate_user!

  def create
    StripeWebhookService.call(request)
    render json: { message: 'success' }
  end
end
