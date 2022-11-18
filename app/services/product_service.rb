# frozen_string_literal: true

# Service object to manage list of products to show in index products
class ProductService < ApplicationService
  def initialize(params = {})
    @params = params
    super()
  end

  def call
    product_scope
    product_search
    product_filter
    product_sort
  end

  private

  attr_reader :params

  def product_scope
    @products = ProductsQuery.new({ search: params[:search], tags: params[:tags],
                                    sort: params[:sort] }).define_scope_for_products
  end

  def product_search
    @products = ProductsQuery.new({ search: params[:search] }, @products).search_products_by_name
  end

  def product_filter
    @products = ProductsQuery.new({ tags: params[:tags] }, @products).filter_products
  end

  def product_sort
    @products = ProductsQuery.new({ sort: params[:sort] }, @products).sort_products
  end
end
