# frozen_string_literal: true

# Class to manage interactions between no logged in users and products
class ProductsController < ApplicationController
  before_action :save_input_states, only: %i[index]
  # before_action :set_product, only: %i[show]

  # Method to get index of products
  # GET /products
  def index
    @products = ProductService.call({ search: params[:search], tag_ids: params[:tag_id], sort: params[:sort_id] })
  end

  # Method to get show product
  # GET /products/:id
  def show
    @comment_form = Forms::CommentForm.new({ product_id: params[:id] }, current_user)
  end

  private

  # Method to find a prodcut by id
  # def set_product
  #   @commentable = Product.find(params[:id])
  # end

  # Method to mantain options of search, filter and sort sections
  def save_input_states
    @search = params[:search].strip unless params[:search].nil?
    @selected_tags_ids = params[:tag_id]
    @selected_sort_id = params[:sort_id]
  end
end
