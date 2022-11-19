# frozen_string_literal: true

module Api
  module V1
    # module Customer
    # Class to manage Likes of a product
    class LikesController < ApiController
      before_action :authorize_request
      before_action :authorize_action

      # Method to like a product
      # - POST /api/v1/customer/likes
      def create
        @like = Customer::Likes::LikeHandler.call(@current_user, params[:product_id])
        render json: json_api_format(LikeRepresenter.new(@like), 'like'), status: :ok
      end

      private

      def authorize_action
        authorize Like
      end
    end
    # end
  end
end
