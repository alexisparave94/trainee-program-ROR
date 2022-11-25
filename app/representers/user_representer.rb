# frozen_string_literal: true

# Class to representar a product in json
class UserRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :first_name
  property :last_name
  property :email
end
