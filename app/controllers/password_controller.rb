# frozen_string_literal: true

# Class to manage passwords
class PasswordController < ApplicationController
  def forgot_password
    @user = ResetPasswordFormGetter.call
  end

  def reset_password
    @user = ResetPasswordSender.call(reset_password_params)
    flash[:notice] = 'Instructions sent'
    render :forgot_password
  end

  private

  def reset_password_params
    params.require(:user).permit(:email)
  end
end
