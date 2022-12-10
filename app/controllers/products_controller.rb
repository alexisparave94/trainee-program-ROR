# frozen_string_literal: true

# Class to manage interactions between no logged in users and products
class ProductsController < ApplicationController
  before_action :save_input_states, only: %i[index]
  # before_action :set_product, only: %i[show]

  # Method to get index of products
  # GET /products
  def index
    run Operations::Index, params:, current_user:, api: nil do |ctx|
      @products = ctx[:products]
    end
  end

  # Method to get show product
  # GET /products/:id
  def show
    result = Operations::Customer::Products::Show.call(
      params: { id: params[:id], current_user: }
    )
    @comment_product_form = result['contract.default']
    @information = result[:information]
  end

  private

  # Method to mantain options of search, filter and sort sections
  def save_input_states
    @search = params[:search].strip unless params[:search].nil?
    @selected_tags = params[:tags]
    @selected_sort = params[:sort]
  end
end
