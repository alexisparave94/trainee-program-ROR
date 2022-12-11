# frozen_string_literal: true

module Customer
  # Class to manage transactions of a customer
  class TransactionsController < ApplicationController
    before_action :authenticate_user!, only: %i[index]

    def index
      # @transactions = Customer::TransactionService.call(current_user)
      run Operations::Customer::Transactions::Index, current_user: do |ctx|
        @transactions = ctx[:transactions]
      end
      # authorize @transactions.first
    end
  end
end
