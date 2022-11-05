# frozen_string_literal: true

# Class to manage Products Controller
class ProductsController < ApplicationController
  # before_action :set_product, only: %i[show]

  # GET /products
  def index
    save_input_states
    define_scope_for_products

    @products = @products.where('LOWER(products.name) LIKE ?', "%#{@search.downcase}%") if params[:search]

    @products = @products.filter_by_tag(@selected_tags_ids) if params[:tag_id] && params[:tag_id].size > 1

    sort_products(params[:sort_id]) unless params[:sort_id] && params[:sort_id].empty?
  end

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

  def sort_products(sort_by)
    case sort_by
    when 'like'
      @products = @products.sort_by_likes
    when 'ASC', 'DESC'
      @products = @products.sort_by_name(sort_by)
    end
  end

  def save_input_states
    @search = params[:search].strip unless params[:search].nil?
    @selected_tags_ids = params[:tag_id]
    @selected_sort_id = params[:sort_id]
  end

  def define_scope_for_products
    @products = Product.all.available_products if validate_default_scope?
    @products = Product.unscoped.available_products if validate_unscoped?
  end

  def validate_unscoped?
    (
      params[:search] == '' && (params[:tag_id].size > 1 || !params[:sort_id].empty?)) ||
      (params[:search] != '' && !params[:search].nil?)
  end

  def validate_default_scope?
    params[:search].nil? || params[:search] == ''
  end
end
