# frozen_string_literal: true

# Mailer to notify purchase details 
class PurchaseDetailsMailer < ApplicationMailer
  default from: 'support@mail.com'

  def purchase_details(email, order)
    @email = email
    @order = order
    mail(to: @email, subject: 'Purchase Details')
  end
end
