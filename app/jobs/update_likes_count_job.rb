# frozen_string_literal: true

# Job to update likes count
class UpdateLikesCountJob < ApplicationJob
  queue_as :default

  def perform(product, count)
    product.likes_count += count
    product.save
  end
end
