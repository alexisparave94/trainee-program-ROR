# frozen_string_literal: true

module Operations
  module Admin
    module Transactions
      # Class to manage operation of list all products
      class Index < Trailblazer::Operation
        step :set_transactions

        def set_transactions(ctx, **)
          ctx[:transactions] = Transaction.all.includes(:user)
        end
      end
    end
  end
end
