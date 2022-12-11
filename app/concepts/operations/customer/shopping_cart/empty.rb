# frozen_string_literal: true

module Operations
  module Customer
    module ShoppingCart
      # Class to manage operation of show a product
      class Empty < Trailblazer::Operation
        step :set_order
        step :pending_order
        step :empty_cart

        def set_order(ctx, params:, **)
          ctx[:order] = Order.find(params[:order_id])
        end

        def pending_order(_ctx, order:, **)
          order.pending?
        end

        def empty_cart(_ctx, order:, **)
          OrderLine.destroy_by(order_id: order.id)
        end
      end
    end
  end
end
