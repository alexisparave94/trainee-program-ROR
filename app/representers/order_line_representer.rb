# frozen_string_literal: true

# Class to representar an order line in json
class OrderLineRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :quantity
  property :price
  property :total
  property :order_id
  property :product, decorator: ProductRepresenter
  property :created_at
  property :updated_at
end
