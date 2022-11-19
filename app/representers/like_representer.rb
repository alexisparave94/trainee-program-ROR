# frozen_string_literal: true

# Class to representar a product in json
class LikeRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :user_id
  property :likeable, decorator: ProductRepresenter
end
