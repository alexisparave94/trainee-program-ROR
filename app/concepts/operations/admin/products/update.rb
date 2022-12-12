# frozen_string_literal: true

module Operations
  module Admin
    module Products
      # Class to manage operation of update a product
      class Update < Trailblazer::Operation
        class Present < Trailblazer::Operation
          step Model(Product, :find_by)
          step Contract::Build(constant: Contracts::Products::Update)
        end

        step Subprocess(Present)
        step Contract::Validate(key: :product)
        step Contract::Persist()

        def save_change_log(ctx, params:, **)
          @log = ChangeLog.new(user: params[:current_user], product: ctx[:model].name, description: 'Create')
          @log.save
        end

        # def call
        #   update_params if @user.support?
        #   validate_params(Forms::EditProductForm.new(@params))
        #   @product.update(@params)
        #   save_change_log
        #   @product
        # end

        # private

        # def update_params
        #   @params = @params.merge(price: @product.price)
        # end

        # # Method to save changes in the product in change log
        # def save_change_log
        #   set_changed_attributes.each do |attr|
        #     ChangeLog.create(
        #       user: @user,
        #       description: 'Update',
        #       product: @product.name,
        #       field: attr[0],
        #       previous_content: attr[1],
        #       new_content: attr[2]
        #     )
        #   end
        # end

        # def set_changed_attributes
        #   attr_before_update = @product.attributes.except('id', 'created_at', 'updated_at', 'likes_count', 'image')
        #   params_hash = @params.to_hash.except('image')
        #   params_hash.map { |key, value| value == attr_before_update[key] ? nil : [key, attr_before_update[key], value]}
        #              .compact
        # end
      end
    end
  end
end
