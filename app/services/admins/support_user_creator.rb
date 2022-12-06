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

      @user = User.new(@params.except('personal_email'))
      @user.role = 'support'
      generate_random_password
      @user.password = @password
      @user.save
      UserMailer.new_support_user(@user, @password, @params[:personal_email]).deliver
      @user
    end

    private

    def parse_errors_api
      @user_form.errors.messages
    end

    def generate_random_password
      @password = Faker::Internet.password(min_length: 8, max_length: 10, mix_case: true)
    end
  end
end
