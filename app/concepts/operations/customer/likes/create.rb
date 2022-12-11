# frozen_string_literal: true

module Operations
  module Customer
    module Likes
      # Class to manage operation of create a commnet of a product
      class Create < Trailblazer::Operation
        step :set_likeable
        step :validate_like
        step :persist_like

        def set_likeable(ctx, params:, **)
          ctx[:likeable] = Product.find(params[:product_id])
        end

        def validate_like(_ctx, current_user:, likeable:, **)
          current_user.likes.where(likeable:).empty?
        end

        def persist_like(_ctx, current_user:, likeable:, **)
          UpdateLikesCountJob.perform_later(likeable, 1)
          Like.create(user: current_user, likeable:)
        end
      end
    end
  end
end
