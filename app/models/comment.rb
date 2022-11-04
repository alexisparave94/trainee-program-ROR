class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  # Scopes
  default_scope { order(created_at: :DESC) }
end
