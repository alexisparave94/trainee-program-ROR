# frozen_string_literal: true

module Operations
  module VirtualOrderLines
    # Class to manage operation of create a product
    class Create < Trailblazer::Operation
      # Class to manage operation to get form to create a product
      class Present < Trailblazer::Operation
        step Model(OrderLine, :new)
        step Contract::Build(constant: Contracts::OrderLines::Create)
        step :set_product

        def set_product(ctx, params:, **)
          ctx[:product] = params[:product_id] ? Product.find(params[:product_id]) : Product.find(params[:order_line][:product_id])
        end
      end

      step Subprocess(Present)
      step Contract::Validate(key: :order_line)
      step :add_virtual_product

      def add_virtual_product(ctx, params:, virtual_order:, product:, **)
        ctx[:virtual_line] = look_for_virtual_line_in_virtual_order(virtual_order, product)
        if ctx[:virtual_line]
          ctx[:virtual_line]['quantity'] += params[:order_line][:quantity].to_i
        else
          virtual_order << { id: product.id, name: product.name, price: product.price.to_f,
                             quantity: params[:order_line][:quantity].to_i }
        end
      end

      private

      # Method to look for a product in a virtual order
      def look_for_virtual_line_in_virtual_order(virtual_order, product)
        virtual_order.select { |line| line['id'] == product.id }.first
      end
    end
  end
end
