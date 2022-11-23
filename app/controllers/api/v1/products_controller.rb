# frozen_string_literal: true

module Api
  module V1
    # Class to manage interactions between no logged in users and products
    class ProductsController < ApiController
      # Method to get index of products
      # GET /api/v1/products
      swagger_path '/products' do
        operation :get do
          key :description, 'Returns all products'
          key :operationId, 'findProducts'
          key :tags, [
            'product'
          ]
          parameter name: :search, in: :query do
            key :description, 'word to look for on names fo products'
            key :type, :string
          end
          parameter name: :limit, in: :query do
            key :description, 'maximum number of results to return'
            key :type, :integer
          end
          parameter name: :page, in: :query do
            key :description, 'number of page to return'
            key :type, :integer
          end
          response 200, description: 'Products response' do
            schema '$ref': :MetaPagination
          end
          response 422, description: 'Unprocessable entity' do
            schema '$ref': :ErrorModel
          end
        end
      end

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
            schema '$ref': :ProductSimpleResponse
          end
          response 404 do
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
