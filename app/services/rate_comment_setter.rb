class RateCommentSetter < ApplicationService
  def initialize(current_user, product)
    @current_user = current_user
    @product = product
  end

  def call
    set_rate
  end

  private

  attr_reader :current_user, :product

  def set_rate
    Comment.new(rate: get_last_rate(product))
  end

  def get_last_rate(product)
    current_user && current_user.comments.where(commentable_id: product.id).order(created_at: :DESC).first&.rate
  end
end
