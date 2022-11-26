module SwaggerControllers
  module ApidocsController
    extend ActiveSupport::Concern
    included do
      include Swagger::Blocks
      swagger_root do
        key :swagger, '2.0'
        info do
          key :version, '1.0.0'
          key :title, 'App Store'
          key :description, 'An online store'
        end
        tag do
          key :name, 'product'
          key :description, 'Product operations'
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
      SWAGGERED_CLASSES = [
        Api::V1::ProductsController,
        # Controllers::ProductsController,
        # Api::V1::SessionsController,
        # Api::V1::OrdersController,
        SwaggerControllers::ProductsController,
        SwaggerModels::ProductSwagger,
        SwaggerModels::MetaPagination,
        # Api::V1::Session,
        # Api::V1::OrderLineSwagger,
        # Api::V1::OrderSwagger,
        # Api::V1::Session,
        SwaggerModels::ErrorModel,
        self
      ].freeze

      def index
        render json: Swagger::Blocks.build_root_json(SWAGGERED_CLASSES)
      end
    end
  end
end
