# frozen_string_literal: true

class ProductsController < ApplicationController
  # before_action :set_product, only: %i[show]

  # GET /products
  def index
    @products = Product.all.available_products
    if params[:search]
      @search = params[:search]
      @products = @products.where('LOWER(name) LIKE ?', "%#{@search.downcase}%")
    elsif params[:tag_id] && params[:tag_id].size > 1
      @selected_tags_ids = params[:tag_id]
      @products = @products.filter_by_tag(@selected_tags_ids)
    end
    order_products(params[:order]) if params[:order]
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

  def order_products(order_by)
    case order_by
    when 'like'
      @products = @products.order_by_likes
    when 'ASC', 'DESC'
      @products = @products.order_by_name(order_by)
    end
  end
end
