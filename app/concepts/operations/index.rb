# frozen_string_literal: true

module Operations
  # Class to manage operation of list all products
  class Index < Trailblazer::Operation
    step :set_user
    step :discard_products
    step :product_scope
    step :product_search
    step :product_filter
    step :product_sort
    step :paginate

    def set_user(ctx, current_user:, **)
      ctx[:user] = current_user
    end

    def discard_products(ctx, **)
      ctx[:products] = Queries::ProductsQuery.new(nil, Product.all, ctx[:user]).filter_discarded_products
    end

    def product_scope(ctx, params:, **)
      ctx[:products] = Queries::ProductsQuery.new({ search: params[:search], tags: params[:tags],
                                                    sort: params[:sort] }, ctx[:products]).define_scope_for_products
    end

    def product_search(ctx, params:, **)
      ctx[:products] = Queries::ProductsQuery.new({ search: params[:search] }, ctx[:products]).search_products_by_name
    end

    def product_filter(ctx, params:, **)
      ctx[:products] = Queries::ProductsQuery.new({ tags: params[:tags] }, ctx[:products]).filter_products
    end

    def product_sort(ctx, params:, **)
      ctx[:products] = Queries::ProductsQuery.new({ sort: params[:sort] }, ctx[:products]).sort_products
    end

    def paginate(ctx, params:, api:, **)
      api ? ResourcesPaginator.call(ctx[:products], params) : ctx[:products]
    end
  end
end
