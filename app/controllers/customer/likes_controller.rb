# frozen_string_literal: true

module Customer
  # Class to manage Likes Controller of the namespace from customer
  class LikesController < ApplicationController
    # POST /customer/likes
    def create
      @product = Product.find(params[:product_id])
      @like = Like.new(user: current_user, likeable: @product)
      authorize @like
      @like.save
      redirect_to products_path, notice: 'Product liked successfully'
    end

    # DELETE /customer/likes/:id
    def destroy
      @like = Like.find(params[:id])
      authorize @like
      @like.destroy
      redirect_to products_path, notice: 'Product disliked successfully'
    end
  end
end
