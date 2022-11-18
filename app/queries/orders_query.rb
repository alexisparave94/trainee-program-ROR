# frozen_string_literal: true

# Class to manage service of search, filter and sort for products
class OrdersQuery
  attr_reader :relation, :params

  def initialize(params = {}, relation = Product.all)
    @relation = relation
    @params = params
  end

  def completed_orders
    relation.includes(:order_lines).where(status: params[:status]).order(created_at: :DESC)
  end
end
