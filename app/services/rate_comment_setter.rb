class RateCommentSetter < ApplicationService
  def initialize(current_user, product)
    @current_user = current_user
    @product = product
  end

  def call
    set_current_user_rate
  end

  private

  attr_reader :current_user, :product

  def set_current_user_rate
    current_user && current_user.rates.where(rateable_id: product.id).take
  end
end
