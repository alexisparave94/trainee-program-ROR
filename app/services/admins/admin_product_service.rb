# frozen_string_literal: true

module Admins
  # Service object parent of a admins product services
  class AdminProductService < ApplicationService
    def initialize(params, user, token = nil)
      @params = params
      @user = user
      @token = token
      super()
    end

    protected

    def validate_params(object_form)
      handle_error(object_form, @token)
    end
  end
end
