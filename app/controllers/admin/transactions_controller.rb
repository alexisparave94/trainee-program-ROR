# frozen_string_literal: true

module Admin
  class TransactionsController < ApplicationController
    def index
      authorize Transaction
      @transactions = Admins::TransactionService.call
    end
  end
end