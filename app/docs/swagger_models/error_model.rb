# frozen_string_literal: true

module SwaggerModels
  class ErrorModel < ActiveRecord::Base
    include Swagger::Blocks

    swagger_schema :ErrorModel do
      property :error do
        key :type, :string
      end
      property :status do
        key :type, :string
      end
      property :message do
        key :type, :string
      end
    end
  end
end
