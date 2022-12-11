# frozen_string_literal: true

module Operations
  module Admin
    module Comments
      # Class to manage operation of delete a product
      class Approve < Trailblazer::Operation
        step Model(Comment, :find_by)
        step :approve

        def approve(_ctx, model:, **)
          model.update(status: 'approved')
        end
      end
    end
  end
end
