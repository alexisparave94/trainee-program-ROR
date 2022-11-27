# frozen_string_literal: true

module SwaggerControllers
  module Helpers
    module ApidocsHelper
      CONTROLLERS = [
        SwaggerControllers::ProductsController,
        SwaggerControllers::Admin::ProductsController,
        SwaggerControllers::SessionsController,
        SwaggerControllers::OrdersController
      ].freeze
      MODELS = [
        SwaggerModels::ProductSwagger,
        SwaggerModels::MetaPagination,
        SwaggerModels::Session,
        SwaggerModels::OrderSwagger,
        SwaggerModels::OrderLineSwagger,
        SwaggerModels::ErrorModel
      ].freeze
    end
  end
end
