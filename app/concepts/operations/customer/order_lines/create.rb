# frozen_string_literal: true

module Operations
  module Customer
    module OrderLines
      # Class to manage operation of create a product
      class Create < Trailblazer::Operation
        # Class to manage operation to get form to create a product
        class Present < Trailblazer::Operation
          step Model(OrderLine, :new)
          step Contract::Build(constant: Contracts::OrderLines::Create)
          step :set_product

          def set_product(ctx, params:, **)
            pp '?????????????'
            pp params
            ctx[:product] = Product.find(params[:product_id])
          end
        end

        step Subprocess(Present)
        step Contract::Validate(key: :product)
        step Contract::Persist()
        step :create_stripe_product
        step :save_change_log

        # Method to save changes in the product in change log
      end
    end
  end
end
