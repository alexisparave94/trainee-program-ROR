# frozen_string_literal: true

module Customer
  # Class to manage Likes of a product
  class LikesController < ApplicationController
    before_action :authorize_action

    # Method to like a product
    # - POST /customer/likes
    def create
      run Operations::Customer::Likes::Create, params:, current_user: do
        redirect_to products_path, notice: 'Product liked successfully'
      end
      # Customer::Likes::LikeHandler.call(current_user, params[:product_id])
    end

    # Method to dislike a product
    # - DELETE /customer/likes/:id
    def destroy
      run Operations::Customer::Likes::Delete
      # Customer::Likes::DislikeHandler.call(params[:id])
      redirect_to products_path, notice: 'Product disliked successfully'
    end

    private

    def authorize_action
      authorize Like
    end
  end
end
