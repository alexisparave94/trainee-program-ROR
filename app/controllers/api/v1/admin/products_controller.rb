# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Class to manage interactions between no logged in users and products
      class ProductsController < ApiController
        before_action :authorize_request
        before_action :authorize_action
        before_action :set_product, only: %i[update destroy]

        # Method to create a new product
        # - POST /api/v1/admin/products
        def create
          @product = Admins::ProductCreator.new(product_form_params, @current_user).call
          render json: @product, status: :ok
        end

        # Method to update a product
        # - PATCH /api/v1/admin/product_forms/:id
        def update
          @product = Admins::ProductUpdater.new(product_form_params, params[:id], @current_user).call
          render json: @product, status: :ok
        end

        # Method to delete a product
        # - DELETE /api/v1/admin/products/:id
        def destroy
          @product = Admins::ProductDeleter.call(@product, @current_user)
          render json: @product, status: :no_content
        end

        private

        # Method to set strong params for product form
        def product_form_params
          params.require(:forms_product_form).permit(policy(Product).permitted_attributes)
        end

        # Method to set a specific product
        def set_product
          @product = ProductGetter.call(params[:id])
        end

        # Method to authorize actions
        def authorize_action
          authorize Product
        end
      end
    end
  end
end