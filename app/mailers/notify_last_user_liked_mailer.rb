# frozen_string_literal: true

# Mailer to notify last user liked a producst when the product reaches a stock of 3
class NotifyLastUserLikedMailer < ApplicationMailer
  # default from: 'aparavev@gmail.com'
  default from: 'support@mail.com'

  def notify(*args)
    pp @email = args[0][:email]
    pp @products = args[0][:products]
    pp '======================'
    mail(to: @email, subject: 'Products that you liked has low stock')
  end
end
