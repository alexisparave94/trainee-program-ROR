# frozen_string_literal: true

module Operations
  module VirtualOrderLines
    # Class to manage operation of create a product
    class Update < Trailblazer::Operation
      # Class to manage operation to get form to create a product
      class Present < Trailblazer::Operation
        step Model(OrderLine, :new)
        step Contract::Build(constant: Contracts::OrderLines::Create)
        pass :set_product
        pass :set_quantity

        def set_product(ctx, params:, **)
          ctx[:product] = Product.find(params[:id])
        end

        def set_quantity(ctx, params:, **)
          ctx['contract.default'].quantity = params[:quantity]
        end
      end

      step Subprocess(Present)
      step :set_edit_product
      step Contract::Validate(key: :order_line)
      step :define_virtual_line
      step :set_quantity_for_virtual_line

      def set_edit_product(ctx, params:, **)
        ctx[:product] = Product.find(params[:order_line][:product_id])
      end

      def define_virtual_line(ctx, virtual_order:, product:, **)
        ctx[:virtual_line] = virtual_order.select { |line| product.id.to_i == line['id'].to_i }.first
      end

      def set_quantity_for_virtual_line(_ctx, params:, virtual_line:, **)
        virtual_line['quantity'] = params[:order_line][:quantity].to_i
      end
    end
  end
end
