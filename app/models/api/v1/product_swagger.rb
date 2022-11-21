# frozen_string_literal: true

# Definition for response of a product
module Api
  module V1
    class ProductSwagger < ActiveRecord::Base
      include Swagger::Blocks

      swagger_schema :ProductSwagger do
        property :data do
          property :id do
            key :type, :integer
            key :format, :int64
          end
          property :sku do
            key :type, :string
          end
          property :name do
            key :type, :string
          end
          property :stock do
            key :type, :integer
            key :format, :int64
          end
          property :price do
            key :type, :double
          end
          property :likes_count do
            key :type, :integer
            key :format, :int64
          end
        end
      end

      swagger_schema :ProductInputSwagger do
        key :required, %i[forms_new_product_form]
        property :forms_new_product_form do
          key :required, %i[name sku]
          property :sku do
            key :type, :string
          end
          property :name do
            key :type, :string
          end
          property :description do
            key :type, :string
          end
          property :price do
            key :type, :string
          end
          property :stock do
            key :type, :string
          end
        end
      end
    end
  end
end
