# frozen_string_literal: true

module Operations
  module Api
    module V1
      module Admin
        module Comments
          # Class to manage operation of create a product
          class Delete < Trailblazer::Operation
            step Model(Comment, :find_by)
            step :delete

            def delete(_ctx, model:, **)
              model.destroy
            end
          end
        end
      end
    end
  end
end
