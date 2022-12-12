# frozen_string_literal: true

module Operations
  module Api
    module V1
      module Admin
        module Products
          # Class to manage operation of show a product api
          class Show < Trailblazer::Operation
            step Model(Product, :find_by)
            step :available_product

            def available_product(_ctx, user:, model:, **)
              raise(NotValidEntryRecord, 'Products has been disabled') if model.discarded? &&
                                                                          (user.nil? || user.customer?)

              true
            end
          end
        end
      end
    end
  end
end
