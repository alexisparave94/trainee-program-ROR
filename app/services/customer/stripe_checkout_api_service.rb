# frozen_string_literal: true

module Customer
  # Service object to checkout order lines of a shopping cart
  # for a logged in customer user
  class StripeCheckoutApiService < StripeCheckoutService

    def call
      raise(NotValidEntryRecord, 'The purchase has been completed') unless @order.pending?

      raise(NotEnoughStock, lines_exceed_stock.compact) unless lines_exceed_stock.compact.empty?

      session
    end
  end
end
