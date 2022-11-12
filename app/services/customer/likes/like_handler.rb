# frozen_string_literal: true

module Customer
  module Likes
    # Service object to like a product
    class LikeHandler < ApplicationService
      def initialize(current_user, product_id)
        @current_user = current_user
        @product_id = product_id
        super()
      end

      def call
        like
      end

      private

      def like
        Like.create(user: @current_user,
                    likeable: Product.find(@product_id))
      end
    end
  end
end
