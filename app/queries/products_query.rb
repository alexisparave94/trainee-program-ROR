# frozen_string_literal: true

# Class to manage service of search, filter and sort for products
class ProductsQuery
  attr_reader :relation, :params

  def initialize(params = {}, relation = Product.all)
    @relation = relation
    @params = params
  end

  # Method to scope or unscope products
  def define_scope_for_products
    return available_unscoped_for_customers if validate_unscoped?

    available_for_customers if validate_default_scope?
  end

  def available_for_admin
    relation.include_likes
  end

  # Method to search products by name
  def search_products_by_name
    return relation.where('LOWER(products.name) LIKE ?', "%#{params[:search].downcase}%") if params[:search]

    relation
  end

  # Method to filter products by tags
  def filter_products
    return relation.joins(:tags).where(tags: { id: params[:tag_ids] }) if params[:tag_ids] && params[:tag_ids].size > 1

    relation
  end

  # Method to sort products
  def sort_products
    return relation if params[:sort].nil? || params[:sort] == ''

    sort_by = params[:sort]
    case sort_by
    when 'like'
      relation.order(likes_count: :DESC)
    when 'ASC', 'DESC'
      relation.order(name: sort_by)
    end
  end

  private

  # Method to get available products for customers
  def available_for_customers
    relation.includes(:likes, :tags, :rates).where('stock > 0')
  end

  # Method to get available products unscopes for customers
  def available_unscoped_for_customers
    relation.unscoped.includes(:likes, :tags, :rates).where('stock > 0')
  end

  # Method to validate unscoped porducts
  def validate_unscoped?
    (params[:search] == '' && (params[:tag_ids].size > 1 || !params[:sort].empty?)) ||
      (params[:search] != '' && !params[:search].nil?)
  end

  # Method to validate scoped by default porducts
  def validate_default_scope?
    params[:search].nil? || params[:search] == ''
  end
end
