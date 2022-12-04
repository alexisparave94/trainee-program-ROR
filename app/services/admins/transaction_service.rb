# frozen_string_literal: true

module Admins
  # Service object to delete a comment
  class TransactionService < ApplicationService
    def call
      list_transactions
    end

    def list_transactions
      Transaction.all.includes(:user)
    end
  end
end
