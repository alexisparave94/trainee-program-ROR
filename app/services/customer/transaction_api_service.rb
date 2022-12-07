# frozen_string_literal: true

module Customer
  # Service object to delete a comment
  class TransactionApiService < ApplicationService
    def initialize(user = nil)
      super()
      @user = user
      @list_transactions = @user.transactions
    end

    def call
      raise(NotAuthorizeUser) unless @user&.customer?
      raise(NotAuthorizeUser) unless @list_transactions.first.user == @user

      @list_transactions
    end
  end
end
