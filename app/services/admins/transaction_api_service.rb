# frozen_string_literal: true

module Admins
  # Service object to delete a comment
  class TransactionApiService < ApplicationService
    def initialize(user = nil)
      @user = user
      super()
    end
    
    def call
      raise(NotAuthorizeUser) unless @user&.admin?

      list_transactions
    end

    def list_transactions
      Transaction.all.includes(:user)
    end
  end
end
