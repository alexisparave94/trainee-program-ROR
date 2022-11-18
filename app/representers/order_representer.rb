# frozen_string_literal: true

# Class to representar a product in json
class OrderRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :status
  property :total
  property :user_id
  property :created_at
  property :updated_at

  collection :order_lines, decorator: OrderLineRepresenter, wrap: false
end
