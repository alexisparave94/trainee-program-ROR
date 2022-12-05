# frozen_string_literal: true

# Mailer to notify purchase details 
class PurchaseDetailsMailer < ApplicationMailer
  default from: 'support@mail.com'

  def purchase_details(email, order)
    @email = email
    @order = order
    mail(to: @email, subject: 'Purchase Details')
  end

  def incompleted_purchase(email, message)
    @email = email
    @message = message
    mail(to: @email, subject: 'Incompleted Purchase')
  end
end
