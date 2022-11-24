# frozen_string_literal: true

module Customer
  module Likes
    # Service object to delete like of product
    class DislikeHandler < ApplicationService
      def initialize(id)
        @id = id
        @like = Like.find(@id)
        @product = @like.likeable
        super()
      end

      def call
        dislike
        @like
      end

      private

      def dislike
        @like.destroy
        UpdateLikesCountJob.perform_later(@product, -1)
      end
    end
  end
end
