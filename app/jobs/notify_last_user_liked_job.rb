# frozen_string_literal: true

# Job to notify last user liked a producst when the product reaches a stock of 3
class NotifyLastUserLikedJob < ApplicationJob
  queue_as :default

  def perform(user_and_products)
    NotifyLastUserLikedMailer.notify(user_and_products).deliver
  end
end
