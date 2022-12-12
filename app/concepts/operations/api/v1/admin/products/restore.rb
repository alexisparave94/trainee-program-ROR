# frozen_string_literal: true

module Operations
  module Api
    module V1
      module Admin
        module Products
          # Class to manage operation of create a product
          class Restore < Trailblazer::Operation
            step Model(Product, :find_by)
            step :handle_error
            pass :restore_product
            step :save_change_log

            def handle_error(_ctx, model:, **)
              raise(NotValidEntryRecord, 'Product is not discarted') unless model.discarded?

              true
            end

            def restore_product(_ctx, model:, **)
              model.undiscard
            end

            def save_change_log(_ctx, model:, user:, **)
              @log = ChangeLog.new(user:, product: model.name, description: 'Restore')
              @log.save
            end
          end
        end
      end
    end
  end
end
