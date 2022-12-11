# frozen_string_literal: true

# Class to manage passwords
class PasswordController < ApplicationController
  def forgot_password
    # @user = ResetPasswordFormGetter.call
    run Operations::Passwords::ForgotPassword do |ctx|
      @user = ctx[:model]
    end
  end

  def reset_password
  #   @user = ResetPasswordSender.call(reset_password_params)
  #   flash[:notice] = 'Instructions sent'
  #   render :forgot_password
  # rescue StandardError
  #   redirect_to forgot_password_path
    run Operations::Passwords::ResetPassword,
        params: { email: reset_password_params['email'], user: { email: reset_password_params['email'] } } do |ctx|
      @user = ctx[:model]
      flash[:notice] = 'Instructions sent'
      render :forgot_password
      return
    end
    redirect_to forgot_password_path
  end

  private

  def reset_password_params
    params.require(:user).permit(:email)
  end
end
