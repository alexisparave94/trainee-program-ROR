# Preview all emails at http://localhost:3000/rails/mailers/purchase_details_mailer
class PurchaseDetailsMailerPreview < ActionMailer::Preview
  def purchase_details
    PurchaseDetailsMailer.purchase_details(User.find(3).email, Order.first)
  end

  def incompleted_purchase
    PurchaseDetailsMailer.incompleted_purchase(User.find(3).email, 'Rejected')
  end
end
