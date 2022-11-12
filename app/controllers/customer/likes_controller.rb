# frozen_string_literal: true

module Customer
  # Class to manage Likes of a product
  class LikesController < ApplicationController
    before_action :authorize_action

    # Method to like a product
    # - POST /customer/likes
    def create
      Customer::Likes::LikeHandler.call(current_user, params[:product_id])
      redirect_to products_path, notice: 'Product liked successfully'
    end

    # Method to dislike a product
    # - DELETE /customer/likes/:id
    def destroy
      Customer::Likes::DislikeHandler.call(params[:id])
      redirect_to products_path, notice: 'Product disliked successfully'
    end

    private

    def authorize_action
      authorize Like
    end
  end
end
