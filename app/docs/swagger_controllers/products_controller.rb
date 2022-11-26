module SwaggerControllers
  class ProductsController
    # def self.included(base)
    #   base.class_eval do
    include Swagger::Blocks
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

    swagger_path '/admin/products' do
      operation :post do
        key :summary, 'Create a product'
        key :description, 'Create a product'
        key :operationId, 'createProduct'
        key :tags, ['admin-product']
        security Bearer: []
        parameter name: :product_data, in: :body do
          key :description, 'Data to create a product'
          key :required, true
          schema '$ref': :NewProductInput
        end
        response 200, description: 'Successfull response' do
          schema '$ref': :ProductSimpleResponse
        end
        response 401, description: 'unauthorized' do
          schema '$ref': :ErrorModel
        end
        response 422, description: 'Unprocessable entity' do
          schema '$ref': :ErrorModel
        end
      end
    end

    swagger_path '/admin/products/{id}' do
      operation :patch do
        key :summary, 'Update A Product'
        key :description, 'Update a single product'
        key :operationId, 'updateProduct'
        key :tags, ['admin-product']
        security Bearer: []
        parameter name: :id, in: :path, type: :integer do
          key :description, 'ID of product to update'
          key :required, true
        end
        parameter name: :product_data, in: :body do
          key :description, 'Data to update a product'
          key :required, true
          schema '$ref': :EditProductInput
        end
        response 200, description: 'Product Updated' do
          schema '$ref': :ProductSimpleResponse
        end
        response 404, description: 'Record not found' do
          schema '$ref': :ErrorModel
        end
        response 422, description: 'Unprocessable entity' do
          schema '$ref': :ErrorModel
        end
      end
    end

    swagger_path '/admin/products/{id}' do
      operation :delete do
        key :description, 'deletes a product based on the ID supplied'
        key :operationId, 'deleteProduct'
        key :tags, ['admin-product']
        security Bearer: []
        parameter name: :id, in: :path, type: :integer do
          key :description, 'ID of product to delete'
          key :required, true
        end
        response 204, description: 'product deleted'
        response 401, description: 'unauthorized' do
          schema '$ref': :ErrorModel
        end
        response 404, description: 'Record not found' do
          schema '$ref': :ErrorModel
        end
      end
    end
    # end
  end
end
