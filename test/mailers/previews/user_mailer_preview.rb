# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def reset_password_instructions
    UserMailer.reset_password_instructions(User.second)
  end

  def new_support_user
    UserMailer.new_support_user(User.find(4), 'xxxxxxx', 'example@mail.com')
  end
end
