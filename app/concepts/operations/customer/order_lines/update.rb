# frozen_string_literal: true

module Operations
  module Customer
    module OrderLines
      # Class to manage operation of create a product
      class Update < Trailblazer::Operation
        class Present < Trailblazer::Operation
          step Model(OrderLine, :find_by)
          step Contract::Build(constant: Contracts::OrderLines::Create)
          step :set_product

          def set_product(ctx, params:, **)
            ctx[:product] = params[:product_id] ? Product.find(params[:product_id]) : Product.find(params[:order_line][:product_id])
          end
        end

        step Subprocess(Present)
        step Contract::Validate(key: :order_line)
        step Contract::Persist()
      end
    end
  end
end
