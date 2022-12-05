# frozen_string_literal: true

module Customer
  
  class TransactionsController < ApplicationController
    before_action :authenticate_user!, only: %i[index]

    def index
      @transactions = Customer::TransactionService.call(current_user)
      authorize @transactions.first
    end
  end
end