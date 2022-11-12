class RateCommentSetter < ApplicationService
  def initialize(current_user, commentable)
    @current_user = current_user
    @commentable = commentable
  end

  def call
    set_current_user_rate
  end

  private

  attr_reader :current_user, :commentable

  def set_current_user_rate
    current_user && current_user.rates.where(rateable_id: commentable.id).take
  end
end
