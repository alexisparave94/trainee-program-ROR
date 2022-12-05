# frozen_string_literal: true

module Customer
  # Service object to delete a comment
  class TransactionService < ApplicationService
    def initialize(user)
      @user = user
    end
    
    def call
      list_transactions
    end

    def list_transactions
      @user.transactions
    end
  end
end
