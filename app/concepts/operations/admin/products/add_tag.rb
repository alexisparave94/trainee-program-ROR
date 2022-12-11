# frozen_string_literal: true

module Operations
  module Admin
    module Products
      # Class to manage operation to add a tag to a product
      class AddTag < Trailblazer::Operation
        step Model(Product, :find_by)
        step :add_tag

        def add_tag(_ctx, model:, params:, **)
          model.tags << Tag.find(params[:tag_id])
        end
      end
    end
  end
end
