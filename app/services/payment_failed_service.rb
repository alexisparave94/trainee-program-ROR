# frozen_string_literal: true

# Service object for stripe payment failed webhook
class PaymentFailedService < StripeWebhookService
  private

  def handle_event
    case @event.type
    when 'payment_intent.payment_failed'
      err = @event_object.last_payment_error
      PurchaseDetailsMailer.incompleted_purchase(@user.email, err.message).deliver
      @user.transactions.create(status: 'failed', description: err.message, amount: @event_object.amount)
      400
    end
  end
end
