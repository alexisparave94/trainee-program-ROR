# frozen_string_literal: true

module Operations
  module Customer
    module StripeWebhooks
      # Class to manage operation of show a product
      class PaymentFailed < Trailblazer::Operation
        step :validate_webhook
        step :set_event_object
        step :set_user
        step :handle_event

        def validate_webhook(ctx, request:, **)
          payload = request.body.read
          sig_header = request.env['HTTP_STRIPE_SIGNATURE']
          ctx[:event] = nil

          begin
            ctx[:event] = Stripe::Webhook.construct_event(
              payload, sig_header, ENV.fetch('PAYMENT_INTENT_FAILED_KEY', nil)
            )
          rescue JSON::ParserError => e
            p e
            400
          rescue Stripe::SignatureVerificationError => e
            # Invalid signature
            puts 'Signature error'
            p e
            400
          end
        end

        def set_event_object(ctx, event:, **)
          ctx[:event_object] = event.data.object
        end

        def set_user(ctx, event_object:, **)
          ctx[:user] = User.find_by(stripe_customer_id: event_object.customer)
        end

        def handle_event(ctx, event:, event_object:, user:, **)
          case event.type
          when 'payment_intent.payment_failed'
            err = event_object.last_payment_error
            PurchaseDetailsMailer.incompleted_purchase(user.email, err.message).deliver
            user.transactions.create(status: 'failed', description: err.message, amount: event_object.amount)
            ctx[:status] = 400
          end
        end
      end
    end
  end
end
