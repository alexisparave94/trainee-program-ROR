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
    return relation.joins(:tags).where(tags: { name: params[:tags] }) if params[:tags] &&
                                                                         (params[:tags].size > 1 ||
                                                                         params[:tags][0] != '')

    relation
  end

  # Method to sort products
  def sort_products
    return relation if params[:sort].nil? || params[:sort] == ''

    set_sort_order
    if @sort_order
      relation.order("#{@sort_by} #{@sort_order}")
    else
      relation.order(@sort_by)
    end
  end

  private

  # Method to get available products for customers
  def available_for_customers
    relation.includes(:likes, :tags, :rates,
                      image_attachment: { blob: { variant_records: { image_attachment: :blob } } }).where('stock > 0')
  end

  # Method to get available products unscopes for customers
  def available_unscoped_for_customers
    relation.unscoped.includes(:likes, :tags, :rates,
                               image_attachment: { blob: { variant_records: { image_attachment: :blob } } })
            .where('stock > 0')
  end

  # Method to validate unscoped porducts
  def validate_unscoped?
    valid_combination_of_search_tags_and_sort_params? || valid_sort_params?
  end

  # Method to validate scoped by default porducts
  def validate_default_scope?
    params[:search].nil? || params[:search] == ''
  end

  def set_sort_order
    return @sort_by = params[:sort] unless params[:sort][0] == '-'

    @sort_by = params[:sort][1..]
    @sort_order = 'DESC'
  end

  def valid_combination_of_search_tags_and_sort_params?
    (params[:search] == '' && (params[:tags].size > 1 || !params[:sort].empty?)) ||
      (params[:search] != '' && !params[:search].nil?)
  end

  def valid_sort_params?
    (params[:sort] && !params[:sort].empty?)
  end
end
