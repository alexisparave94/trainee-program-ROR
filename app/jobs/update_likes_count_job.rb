class UpdateLikesCountJob < ApplicationJob
  queue_as :default

  def perform(product, count)
    product.likes_count += count
    product.save
  end
end
