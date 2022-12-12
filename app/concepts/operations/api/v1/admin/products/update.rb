# frozen_string_literal: true

module Operations
  module Api
    module V1
      module Admin
        module Products
          # Class to manage operation of create a product
          class Update < Trailblazer::Operation
            step Model(Product, :find_by)
            step Contract::Build(constant: Contracts::Products::Update)
            step Contract::Validate(key: :forms_edit_product_form)
            fail :handle_error
            step Contract::Persist()
            # step :save_change_log

            def handle_error(ctx, **)
              raise(NotValidEntryRecord, ctx['contract.default'].errors.messages)
            end

            # Method to save changes in the product in change log
            # def save_change_log(_ctx, user:, product:, **)
            #   @log = ChangeLog.new(user:, product: product.name, description: 'Create')
            #   @log.save
            # end
          end
        end
      end
    end
  end
end
