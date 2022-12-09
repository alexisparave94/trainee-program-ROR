# frozen_string_literal: true

module Operations
  module Admin
    module Products
      # Class to manage operation of create a product
      class Create < Trailblazer::Operation
        class Present < Trailblazer::Operation
          step Model(Product, :new)
          step Contract::Build(constant: Contracts::Products::Create)
        end

        step Subprocess(Present)
        step Contract::Validate(key: :product)
        step Contract::Persist()
        step :create_stripe_product
        step :save_change_log

        # Method to save changes in the product in change log
        def save_change_log(ctx, params:, **)
          @log = ChangeLog.new(user: params[:current_user], product: ctx[:model].name, description: 'Create')
          @log.save
        end

        def create_stripe_product(ctx, **)
          stripe_product = Stripe::Product.create(name: ctx[:model].name)
          Stripe::Price.create(product: stripe_product, unit_amount: ctx[:model].price, currency: 'usd')
          ctx[:model].update(stripe_product_id: stripe_product.id)
        end
      end
    end
  end
end
