# frozen_string_literal: true

# Mailer to reset passwordof a user
class UserMailer < Devise::Mailer
  helper :application
  include Devise::Controllers::UrlHelpers
  default template_path: 'users/mailer'
  default from: 'support@mail.com'

  def reset_password_instructions(user)
    @user = user
    create_reset_password_token(@user)
    mail(to: @user.email, subject: 'Reset password instructions')
  end

  def new_support_user(user, password, personal_email)
    @user = user
    @password = password
    @personal_email = personal_email
    create_reset_password_token(@user)
    mail(to: personal_email, from: 'admin@mail.com', subject: 'New Support User')
  end

  private

  def create_reset_password_token(user)
    raw, hashed = Devise.token_generator.generate(User, :reset_password_token)
    @token = raw
    user.reset_password_token = hashed
    user.reset_password_sent_at = Time.now.utc
    user.save
  end
end
