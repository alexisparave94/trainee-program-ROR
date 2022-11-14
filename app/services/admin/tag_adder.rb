# frozen_string_literal: true

module Admin
  class TagAdder < ApplicationService
    def initialize(tag_id, product)
      @tag_id = tag_id
      @product = product
      super()
    end

    def call
      add_tag
    end

    private

    def add_tag
      @product.tags << Tag.find(@tag_id)
    end
  end
end
