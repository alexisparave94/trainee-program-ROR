# frozen_string_literal: true

module Operations
  module Customer
    module Orders
      # Class to manage operation of delete a product
      class Delete < Trailblazer::Operation
        step Model(Order, :find_by)
        step :pending_order
        step :delete

        def pending_order(_ctx, model:, **)
          model.pending?
        end

        def delete(_ctx, model:, **)
          model.destroy
        end
      end
    end
  end
end
