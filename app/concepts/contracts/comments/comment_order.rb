# frozen_string_literal: true

module Contracts
  module Comments
    # Class to manage the form to create a product comment
    class CommentOrder < Reform::Form
      property :description
      property :rate_value, virtual: true
      property :commentable_id

      validates :description, presence: { message: 'Must enter a content to comment' }
      validates :rate_value, numericality: { in: 1..10, message: 'Rate must be between 1 and 10' }, allow_blank: true
    end
  end
end
