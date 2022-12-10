# frozen_string_literal: true

module Operations
  module Customer
    module OrderLines
      # Class to manage operation of delete a product
      class Delete < Trailblazer::Operation
        step Model(OrderLine, :find_by)
        step :delete

        def delete(_ctx, model:, **)
          model.destroy
        end
      end
    end
  end
end
