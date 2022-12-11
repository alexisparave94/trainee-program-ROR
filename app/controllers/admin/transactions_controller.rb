# frozen_string_literal: true

module Admin
  # Class to manage transactions controllers for admin
  class TransactionsController < ApplicationController
    def index
      authorize Transaction
      # @transactions = Admins::TransactionService.call
      run Operations::Admin::Transactions::Index do |ctx|
        @transactions = ctx[:transactions]
      end
    end
  end
end
