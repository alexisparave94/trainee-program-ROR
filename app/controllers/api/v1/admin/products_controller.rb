# frozen_string_literal: true

module Api
  module V1
    module Admin
      # Class to manage interactions between no logged in users and products
      class ProductsController < ApiController
        before_action :authorize_request
        before_action :authorize_action
        before_action :set_product, only: %i[update discard]
        before_action :set_product_available, only: %i[destroy restore]

        # Method to get index of products
        # GET /api/v1/admin/products
        def index
          @pagy, @products = ProductService.call(params, @current_user, 'api')
          render json: json_api_format(ProductRepresenter.for_collection.new(@products), 'products', @pagy), status: :ok
        end

        # Method to get show product
        # GET /api/v1/products/:id
        def show
          run Operations::Api::V1::Admin::Products::Show,
              params:, user: @current_user do |ctx|
            @product = ctx[:model]
          end
          # ctx = run Operations::Api::V1::Admin::Products::Show,
          #           params:, user: @current_user
          # @product = ProductGetter.call(params[:id], @current_user)
          render json: json_api_format(ProductRepresenter.new(@product), 'product'), status: :ok
        end

        # Method to create a new product
        # - POST /api/v1/admin/products
        def create
          # @product = Admins::ProductCreator.call(new_product_form_params, @current_user, @token)
          run Operations::Api::V1::Admin::Products::Create,
              params:, user: @current_user, product_params: new_product_form_params do |ctx|
            @product = ctx[:product]
          end
          render json: json_api_format(ProductRepresenter.new(@product), 'product'), status: :ok
        end

        # Method to update a product
        # - PATCH /api/v1/admin/products/:id
        def update
          # @product = Admins::ProductUpdater.call(edit_product_form_params, params[:id], @current_user, @token)
          run Operations::Api::V1::Admin::Products::Update,
              params:, user: @current_user, product_params: edit_product_form_params do |ctx|
            @product = ctx[:model]
          end
          render json: json_api_format(ProductRepresenter.new(@product), 'product'), status: :ok
        end

        # Method to delete a product
        # - DELETE /api/v1/admin/products/:id
        def destroy
          run Operations::Admin::Products::Delete
          # @product = Admins::ProductDeleter.call(@product, @current_user)
          render json: @product, status: :no_content
        end

        # Method to soft delete a product
        # - PATCH /api/v1/admin/products/soft_delete/:id
        def discard
          run Operations::Api::V1::Admin::Products::Discard,
              params:, user: @current_user do |ctx|
            @product = ctx[:model]
          end
          # @product = Admins::ProductSoftDeleter.call(@product, @current_user)
          render json: json_api_format(ProductRepresenter.new(@product), 'product'), status: :ok
        end

        # Method to soft delete a product
        # - PATCH /api/v1/admin/products/soft_delete/:id
        def restore
          # @product = Admins::ProductRestorer.call(@product, @current_user)
          run Operations::Api::V1::Admin::Products::Restore,
              params:, user: @current_user do |ctx|
            @product = ctx[:model]
          end
          render json: json_api_format(ProductRepresenter.new(@product), 'product'), status: :ok
        end

        private

        # Method to set strong params for product form
        def new_product_form_params
          params.require(:forms_new_product_form).permit(policy(Product).permitted_attributes)
        end

        def edit_product_form_params
          params.require(:forms_edit_product_form).permit(policy(Product).permitted_attributes)
        end

        # Method to set a specific product
        def set_product
          @product = ProductGetter.call(params[:id])
        end

        # Method to set a specific product
        def set_product_available
          @product = Product.find(params[:id])
        end

        # Method to authorize actions
        def authorize_action
          authorize Product
        end
      end
    end
  end
end
