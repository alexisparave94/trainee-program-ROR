# frozen_string_literal: true

# Service object to empty a shopping cart
# for a no logged in user
class StripeCheckoutFrontService < StripeCheckoutService
  def call
    raise(StandardError, 'Please check the current stock of the products') unless lines_exceed_stock.compact.empty?

    session
  end
end
