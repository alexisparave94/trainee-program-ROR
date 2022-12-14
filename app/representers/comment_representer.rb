# frozen_string_literal: true

# Class to representer a comment in json
class CommentRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :description
  property :status
  property :user, as: :author, decorator: UserRepresenter
  property :commentable, as: :comment_receiver, decorator: UserRepresenter
  property :created_at
  property :updated_at
end
