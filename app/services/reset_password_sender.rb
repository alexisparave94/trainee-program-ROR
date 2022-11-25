# frozen_string_literal: true

# Service object to get form to reset a password
class ResetPasswordSender < ApplicationService
  def initialize(params)
    @params = params
    @user = User.find_by(email: params[:email])
    super()
  end

  def call
    @reset_password_form = Forms::ResetPasswordForm.new(@params)
    raise(StandardError, parse_errors) unless @reset_password_form.valid?

    UserMailer.welcome_reset_password_instructions(@user).deliver
    @user
  end

  private

  def parse_errors
    @reset_password_form.errors.messages.map { |_key, error| error }.join(', ')
  end
end
