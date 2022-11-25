# frozen_string_literal: true

# Service object to get form to reset a password
class ResetPasswordSender < ApplicationService
  def initialize(params)
    @user = User.find_by(email: params[:email])
    super()
  end

  def call
    UserMailer.welcome_reset_password_instructions(@user).deliver
    @user
  end
end
