# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/notify_last_user_liked_mailer
class NotifyLastUserLikedMailerPreview < ActionMailer::Preview
  def notify
    NotifyLastUserLikedMailer.notify({ email: User.second.email, products: [Product.first] })
  end
end
