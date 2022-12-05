# frozen_string_literal: true

module Admin
  # Class to manage transactions controllers for admin
  class TransactionsController < ApplicationController
    def index
      authorize Transaction
      @transactions = Admins::TransactionService.call
    end
  end
end
