# frozen_string_literal: true

module Operations
  module Customer
    module Transactions
      # Class to manage operation of list all products
      class Index < Trailblazer::Operation
        step :set_transactions

        def set_transactions(ctx, current_user:, **)
          ctx[:transactions] = current_user.transactions
        end
      end
    end
  end
end
