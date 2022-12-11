# frozen_string_literal: true

module Operations
  module Customer
    module Orders
      # Class to manage operation of list all products
      class Index < Trailblazer::Operation
        pass :set_orders

        def set_orders(ctx, current_user:, status:, **)
          ctx[:orders] = Queries::OrdersQuery.new({ status: }, current_user.orders).completed_orders
        end
      end
    end
  end
end
