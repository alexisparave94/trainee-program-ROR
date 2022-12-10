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
            ctx[:product] = params[:product_id] ? Product.find(params[:product_id]) : Product.find(params[:order_line][:product_id])
          end
        end

        step Subprocess(Present)
        step :set_order
        step :order_pending
        step :set_order_line
        step Contract::Validate(key: :order_line)
        step :add_product

        def set_order(ctx, order:, **)
          return ctx[:order] if order

          if ctx[:current_user].orders.where(status: 'pending').empty?
            ctx[:order] = Order.create(user: ctx[:current_user])
          else
            ctx[:order] = ctx[:current_user].orders.where(status: 'pending').take
          end
        end

        def order_pending(ctx, **)
          new_order unless ctx[:order].pending?
          ctx[:order]
        end

        def set_order_line(ctx, **)
          ctx[:order_line] = ctx[:order].order_lines.where(product_id: ctx[:product].id)
        end

        # Method to add a new order line or if the line exists only sum quantities
        def add_product(ctx, params:, order:, product:, **)
          if ctx[:order_line].empty?
            create_order_line(order, product, params)
          else
            ctx[:order_line].first.quantity += params[:order_line][:quantity].to_i
            ctx[:order_line].first.save
          end
          ctx[:order]
        end

        private

        def create_order_line(order, product, params)
          OrderLine.create(
            order_id: order.id,
            product:,
            price: product.price,
            quantity: params[:order_line][:quantity]
          )
        end

        def new_order(ctx, **)
          ctx[:order] = Order.create(user: ctx[:current_user])
        end
      end
    end
  end
end
