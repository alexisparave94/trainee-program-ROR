# frozen_string_literal: true

# Class to representar a product in json
class ProductUrlRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :sku
  property :name
  property :description
  property :stock
  property :price
  property :likes_count
  property :image_url
  property :created_at
  property :updated_at
end
