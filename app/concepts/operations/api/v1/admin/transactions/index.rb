# frozen_string_literal: true

module Operations
  module Api
    module V1
      module Admin
        module Transactions
          # Class to manage operation of list all products
          class Index < Trailblazer::Operation
            pass :authorize_user
            step :set_transactions

            def authorize_user(_ctx, current_user:, **)
              raise(NotAuthorizeUser) unless current_user&.admin?
            end

            def set_transactions(ctx, **)
              ctx[:transactions] = Transaction.all
            end
          end
        end
      end
    end
  end
end
