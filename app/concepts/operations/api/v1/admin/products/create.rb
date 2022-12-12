# frozen_string_literal: true

module Operations
  module Api
    module V1
      module Admin
        module Products
          # Class to manage operation of create a product
          class Create < Trailblazer::Operation
            step Model(Product, :new)
            step Contract::Build(constant: Contracts::Products::Create)
            step Contract::Validate(key: :forms_new_product_form)
            fail :handle_error
            step :persist_product
            step :create_stripe_product
            step :save_change_log

            def handle_error(ctx, **)
              raise(NotValidEntryRecord, ctx['contract.default'].errors.messages)
            end

            def persist_product(ctx, product_params:, **)
              ctx[:product] = Product.create(product_params)
            end

            # Method to save changes in the product in change log
            def save_change_log(_ctx, user:, product:, **)
              @log = ChangeLog.new(user:, product: product.name, description: 'Create')
              @log.save
            end

            def create_stripe_product(_ctx, product:, **)
              stripe_product = Stripe::Product.create(name: product.name)
              Stripe::Price.create(product: stripe_product, unit_amount: product.price, currency: 'usd')
              product.update(stripe_product_id: stripe_product.id)
            end
          end
        end
      end
    end
  end
end
