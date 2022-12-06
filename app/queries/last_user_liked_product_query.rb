# frozen_string_literal: true

# Query onject to find the last user liked a product
class LastUserLikedProductQuery
  attr_reader :relation, :params

  def initialize(params = {}, relation = OrderLine.all)
    @relation = relation
    @params = params
  end

  def likes_of_product_in_order_line
    relation.product.likes
  end

  def last_user_liked
    relation.order(created_at: :DESC).take.user
  end
end
