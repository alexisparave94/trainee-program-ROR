# frozen_string_literal: true

# Class to manage interactions between no logged in users and products
class ProductsController < ApplicationController
  # before_action :set_product, only: %i[show]

  # Method to get index of products
  # GET /products
  def index
    save_input_states
    define_scope_for_products
    search_products
    filter_products
    sort_products
  end

  # Method to get show product
  # GET /products/:id
  def show
    @commentable = Product.find(params[:id])
    @rate = current_user&.get_last_rate(@commentable)
    @comment = Comment.new(rate: @rate)
  end

  private

  # Method to find a prodcut by id
  def set_product
    @product = Product.find(params[:id])
  end

  # Method to mantain options of search, filter and sort sections
  def save_input_states
    @search = params[:search].strip unless params[:search].nil?
    @selected_tags_ids = params[:tag_id]
    @selected_sort_id = params[:sort_id]
  end

  # Method to scope or unscope products
  def define_scope_for_products
    @products = Product.all.available_products if validate_default_scope?
    @products = Product.unscoped.available_products if validate_unscoped?
  end

  # Method to validate unscoped porducts
  def validate_unscoped?
    (params[:search] == '' && (params[:tag_id].size > 1 || !params[:sort_id].empty?)) ||
      (params[:search] != '' && !params[:search].nil?)
  end

  # Method to validate scoped by default porducts
  def validate_default_scope?
    params[:search].nil? || params[:search] == ''
  end

  # Method to search products
  def search_products
    @products = @products.where('LOWER(products.name) LIKE ?', "%#{@search.downcase}%") if params[:search]
  end

  # Method to filter products by tags
  def filter_products
    @products = @products.filter_by_tag(@selected_tags_ids) if params[:tag_id] && params[:tag_id].size > 1
  end

  # Method to sort products
  def sort_products
    return if params[:sort_id].nil? || params[:sort_id] == ''

    sort_by = params[:sort_id]
    case sort_by
    when 'like'
      @products = @products.sort_by_likes
    when 'ASC', 'DESC'
      @products = @products.sort_by_name(sort_by)
    end
  end
end
