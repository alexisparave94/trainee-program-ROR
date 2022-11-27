# frozen_string_literal: true

module SwaggerModels
  class Session < ActiveRecord::Base
    include Swagger::Blocks

    swagger_schema :Session do
      property :data do
        property :session do
          property :first_name do
            key :type, :string
          end
          property :email do
            key :type, :string
          end
          property :token do
            key :type, :string
          end
        end
      end
    end

    swagger_schema :Credentials do
      key :required, %i[email password]
      property :email do
        key :type, :string
      end
      property :password do
        key :type, :string
      end
    end
  end
end
