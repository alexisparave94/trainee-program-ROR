# frozen_string_literal: true

module SwaggerControllers
  # Module to setup swagger
  module ApidocsController
    extend ActiveSupport::Concern
    include SwaggerControllers::Helpers::ApidocsHelper
    included do
      include Swagger::Blocks
      swagger_root do
        key :swagger, '2.0'
        info version: '1.0.0' do
          key :title, 'App Store'
          key :description, 'An online store'
        end
        security_definition :Bearer do
          key :type, :apiKey
          key :name, :Authorization
          key :in, :header
        end
        key :host, 'localhost:3000'
        key :basePath, '/api/v1'
        key :consumes, ['application/json']
        key :produces, ['application/json']
      end

      # A list of all classes that have swagger_* declarations.
      SWAGGERED_CLASSES = [ CONTROLLERS, MODELS, self ].flatten.freeze

      def index
        render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
      end
    end
  end
end
