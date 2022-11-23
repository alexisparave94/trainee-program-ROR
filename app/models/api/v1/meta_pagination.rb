# frozen_string_literal: true

module Api
  module V1
    class MetaPagination < ActiveRecord::Base
      include Swagger::Blocks

      swagger_schema :MetaPagination do
        property :meta do
          property :pagination do
            property :page, type: :integer
            property :limit, type: :integer
            property :total_items, type: :integer
            property :total_pages, type: :integer
            property :prev_page, type: :integer
            property :next_page, type: :integer
            property :last_page, type: :integer
          end
        end
        property :data do
          property :products do
            key :type, :array
            items do
              key :$ref, :ProductSwagger
            end
          end
        end
      end
    end
  end
end
