# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  # Scopes
  default_scope { order(created_at: :DESC) }

  # Enum
  enum :status, %i[pending approved]

  # Validations
  validates :rate,
            numericality: { in: 1..10, message: 'Rate must be between 1 and 10' }, allow_nil: true
end
