# frozen_string_literal: true

module Operations
  module Api
    module V1
      module Admin
        module Products
          # Class to manage operation of create a product
          class Discard < Trailblazer::Operation
            step Model(Product, :find_by)
            pass :discard_product
            step :save_change_log

            def discard_product(_ctx, model:, **)
              model.discard
            end

            def save_change_log(_ctx, model:, user:, **)
              @log = ChangeLog.new(user:, product: model.name, description: 'Soft Delete')
              @log.save
            end
          end
        end
      end
    end
  end
end
