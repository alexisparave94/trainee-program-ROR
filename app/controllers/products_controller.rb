# frozen_string_literal: true

class ProductsController < ApplicationController
  # before_action :set_product, only: %i[show]

  # GET /products
  def index
    @search = params[:search].strip unless params[:search].nil?
    @selected_tags_ids = params[:tag_id]
    @selected_sort_id = params[:sort_id]
    
    @products = params[:search].nil? || params[:search] == '' ?  Product.all.available_products : Product.unscoped.available_products

    @products = @products.where('LOWER(products.name) LIKE ?', "%#{@search.downcase}%") if params[:search]

    @products = @products.filter_by_tag(@selected_tags_ids) if params[:tag_id] && params[:tag_id].size > 1
    
    sort_products(params[:sort_id]) unless params[:sort_id]&.empty?
  end

  # GET /products/:id
  def show
    @comentable = Product.find(params[:id])
    @comment = Comment.new
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
end
