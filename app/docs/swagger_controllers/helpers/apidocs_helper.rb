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
        SwaggerControllers::ProductsController,
        SwaggerControllers::Admin::ProductsController,
        SwaggerControllers::SessionsController,
        SwaggerControllers::OrdersController
      ].freeze
    end
  end
end
