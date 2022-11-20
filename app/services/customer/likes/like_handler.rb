# frozen_string_literal: true

module Customer
  module Likes
    # Service object to like a product
    class LikeHandler < ApplicationService
      def initialize(user, product_id)
        @user = user
        @likeable = Product.find(product_id)
        super()
      end

      def call
        like
      end

      private

      def like
        raise(NotValidEntryRecord, 'You have already liked it') unless like_valid?

        Like.create(user: @user,
                    likeable: @likeable)
      end

      def like_valid?
        @user.likes.where(likeable: @likeable).empty?
      end
    end
  end
end
