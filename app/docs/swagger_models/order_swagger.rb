# frozen_string_literal: true

# Definition for response of a order
module SwaggerModels
  class OrderSwagger < ActiveRecord::Base
    include Swagger::Blocks

    swagger_schema :OrderSwagger do
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :status do
        key :type, :string
      end
      property :total do
        key :type, :string
      end
      property :user_id do
        key :type, :integer
        key :format, :int64
      end
      property :order_lines do
        key :type, :array
        items do
          key :$ref, :OrderLineSwagger
        end
      end
    end

    swagger_schema :OrdersResponse do
      property :data do
        property :orders do
          key :type, :array
          items do
            key :$ref, :OrderSwagger
          end
        end
      end
    end
  end
end
