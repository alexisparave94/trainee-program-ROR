# frozen_string_literal: true

module Admins
  # Service object to create a support user
  class SupportUserCreator < ApplicationService
    def initialize(params)
      @params = params
      super()
    end

    def call
      @user_form = Forms::UserForm.new(@params)
      raise(NotValidEntryRecord, parse_errors_api) unless @user_form.valid?

      @user = User.new(@params)
      @user.role = 'support'
      @user.save
      @user
    end

    private

    def parse_errors_api
      @user_form.errors.messages
    end
  end
end
