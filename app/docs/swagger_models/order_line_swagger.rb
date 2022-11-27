# frozen_string_literal: true

# Definition for response of a oder line
module SwaggerModels
  class OrderLineSwagger < ActiveRecord::Base
    include Swagger::Blocks

    swagger_schema :OrderLineSwagger do
      property :id do
        key :type, :integer
        key :format, :int64
      end
      property :quantity do
        key :type, :string
      end
      property :price do
        key :type, :string
      end
      property :total do
        key :type, :integer
        key :format, :int64
      end
      property :product_id do
        key :type, :double
      end
    end
  end
end
