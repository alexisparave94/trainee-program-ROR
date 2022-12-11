# frozen_string_literal: true

module Operations
  module Passwords
    # Class to manage operation to show form to reset a password
    class ResetPassword < Trailblazer::Operation
      step :set_user
      step Contract::Build(constant: Contracts::Passwords::ResetPassword)
      step Contract::Validate(key: :user)
      step :send_instructions

      def set_user(ctx, params:, **)
        ctx[:model] = User.find_by(email: params[:email])
      end

      def send_instructions(_ctx, model:, **)
        UserMailer.reset_password_instructions(model).deliver
      end

      # def initialize(params)
      #   @params = params
      #   @user = User.find_by(email: params[:email])
      #   super()
      # end
    
      # def call
      #   @reset_password_form = Forms::ResetPasswordForm.new(@params)
      #   raise(StandardError, parse_errors) unless @reset_password_form.valid?
    
      #   UserMailer.reset_password_instructions(@user).deliver
      #   @user
      # end
    
      # private
    
      # def parse_errors
      #   @reset_password_form.errors.messages.map { |_key, error| error }.join(', ')
      # end
    end
  end
end
