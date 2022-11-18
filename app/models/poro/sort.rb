# frozen_string_literal: true

module Poro
  # Class to manage Sort PORO
  class Sort
    attr_reader :query_param, :name

    def initialize(query_param, name)
      @query_param = query_param
      @name = name
    end

    def self.sort_options
      [
        Poro::Sort.new('products.name', 'A-Z'),
        Poro::Sort.new('-products.name', 'Z-A'),
        Poro::Sort.new('-likes_count', 'Likes'),
        Poro::Sort.new('price', 'Price Asc'),
        Poro::Sort.new('-price', 'Price Desc')
      ]
    end
  end
end
