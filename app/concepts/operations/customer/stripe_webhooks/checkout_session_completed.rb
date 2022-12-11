# frozen_string_literal: true

module Operations
  module Customer
    module StripeWebhooks
      # Class to manage operation of show a product
      class CheckoutSessionCompleted < Trailblazer::Operation
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
              payload, sig_header, ENV.fetch('CHECKOUT_SESSION_COMPLETE_KEY', nil)
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
          when 'checkout.session.completed'
            get_session(ctx, event_object)
            set_order(ctx, user)
            ctx[:order].update(status: 'completed', total: ctx[:order].calculate_total)
            PurchaseDetailsMailer.purchase_details(user.email, ctx[:order]).deliver
            line_items(ctx[:session]).data.each do |line_item|
              reduce_stock(line_item)
            end

            Operations::Customer::Notifications::NotifyLastUserLike.call(order: ctx[:order])
            # Customer::LastUserNotifier.call(ctx[:order])
            user.transactions.create(status: 'success', description: 'checkout completed',
                                     amount: event_object.amount_total)
            ctx[:status] = 200
          end
        end

        private

        def get_session(ctx, event_object)
          ctx[:session] = Stripe::Checkout::Session.retrieve({ id: event_object.id, expand: %w[line_items customer_details] })
        end

        def line_items(session)
          session.line_items
        end

        def reduce_stock(line_item)
          product = Product.find_by(stripe_product_id: line_item.price.product)
          product.stock -= line_item.quantity
          product.save
        end

        def set_order(ctx, user)
          ctx[:order] = user.orders.find_by(status: 'pending')
        end
      end
    end
  end
end
