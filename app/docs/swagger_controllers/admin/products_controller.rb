# frozen_string_literal: true

module SwaggerControllers
  module Admin
    class ProductsController
      include Swagger::Blocks
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
    end
  end
end
