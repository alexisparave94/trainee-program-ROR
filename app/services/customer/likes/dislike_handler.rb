# frozen_string_literal: true

module Customer
  module Likes
    # Service object to delete like of product
    class DislikeHandler < ApplicationService
      def initialize(id)
        @id = id
        super()
      end

      def call
        dislike
      end

      private

      def dislike
        Like.find(@id).destroy
      end
    end
  end
end
