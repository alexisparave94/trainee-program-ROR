# frozen_string_literal: true

module Operations
  module Customer
    module Likes
      # Class to manage operation of delete a like
      class Delete < Trailblazer::Operation
        step Model(Like, :find_by)
        step :delete

        def delete(_ctx, model:, **)
          model.destroy
          UpdateLikesCountJob.perform_later(model.likeable, -1)
        end
      end
    end
  end
end
