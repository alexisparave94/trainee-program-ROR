# frozen_string_literal: true

module Operations
  module ShoppingCart
    # Class to manage operation of list all products
    class Index < Trailblazer::Operation
      pass :set_orders
      step :pending_order

      def set_orders(ctx, current_user:, order_id:, virtual_order:, **)
        ctx[:order] = current_user ? Order.find(order_id) : nil
        ctx[:virtual_order] = virtual_order
      end

      def pending_order(_ctx, current_user:, order:, **)
        # !(!current_user || order.pending?)
        return order.pending? if current_user

        true
      end
    end
  end
end
