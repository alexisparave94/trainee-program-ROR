# frozen_string_literal: true

# Module to have error control in a global level
module ErrorHandler
  def self.included(clazz)
    clazz.class_eval do
      # rescue_from StandardError do |e|
      #   respond(:standard_error, 500, e.to_s)
      # end
      rescue_from Pundit::NotAuthorizedError do |e|
        respond(:not_authorized_error, :unauthorized, e.to_s)
      end
      rescue_from ActiveRecord::RecordNotFound do |e|
        respond(:record_not_found, :not_found, e.to_s)
      end
      rescue_from Pagy::OverflowError do |e|
        respond(:over_flow, :unprocessable_entity, e.to_s)
      end
      rescue_from NotValidEntryRecord, NotEnoughStock, NotAuthorizeUser do |e|
        respond(e.error, e.status, e.message)
      end
    end
  end

  private

  def respond(error, status, message)
    json = Helpers::Render.json(error, status, message)
    render json:, status:
  end
end
