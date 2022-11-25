# frozen_string_literal: true

# Class to representar a product in json
class ProductRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :sku
  property :name
  property :description
  property :stock
  property :price
  property :likes_count
  property :created_at
  property :updated_at
  property :discarded_at

  property :image_url, exec_context: :decorator

  def image_url
    # represented.image.attached? ? represented.image.url : ''
    represented.image.attached? ? represented.image.variant(:thumb).processed.url : ''
  end
end
