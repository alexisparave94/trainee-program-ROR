# frozen_string_literal: true

module Api
  module V1
    # Class to manage interactions between no logged in users and products
    class ProductsController < ApiController
      # Method to get index of products
      # GET /api/v1/products
      def index
        @products = ProductService.call({ search: params[:search], tags: params[:tags], sort: params[:sort] })
        paginate(@products, params[:limit])
        @result = add_url_to_result(@result)
        render json: json_api_format(ProductUrlRepresenter.for_collection.new(@result), 'products', @pagy), status: :ok
      end

      # Method to get show product
      # GET /api/v1/products/:id
      swagger_path '/products/{id}' do
        operation :get do
          key :summary, 'Find Product by ID'
          key :description, 'Returns a single product'
          key :operationId, 'findProductById'
          key :tags, [
            'product'
          ]
          parameter name: :id, in: :path do
            key :description, 'ID of product to fetch'
            key :required, true
            key :type, :integer
            key :format, :int64
          end
          response 200 do
            key :description, 'Product response'
            schema '$ref': :ProductSwagger
          end
          response 401 do
            key :description, 'Record not found'
            schema '$ref': :ErrorModel
          end
        end
      end

      def show
        @product = ProductGetter.call(params[:id])
        @result = add_url_to_result(@product)
        render json: json_api_format(ProductUrlRepresenter.new(@result), 'product'), status: :ok
      end
    end
  end
end
