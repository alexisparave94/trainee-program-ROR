# frozen_string_literal: true

# Class to representar a product in json
class ProductRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :name
  property :description
  property :stock
  property :price
  property :likes_count
  property :created_at
  property :updated_at
end
