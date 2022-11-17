# frozen_string_literal: true

module Api
  module V1
    # Class to manage interactions between no logged in users and products
    class ProductsController < ApiController
      # Method to get index of products
      # GET /api/v1/products
      def index
        @products = ProductService.call({ search: params[:search], tags: params[:tags], sort: params[:sort] })
        render json: @products, status: :ok
      end

      # Method to get show product
      # GET /api/v1/products/:id
      def show
        @product = ProductGetter.call(params[:id])
        render json: @product, status: :ok
      end
    end
  end
end
