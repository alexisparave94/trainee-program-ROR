# frozen_string_literal: true

module Admins
  # Service object to delete a comment
  class CommentDeleter < ApplicationService
    def initialize(comment)
      @comment = comment
      super()
    end

    def call
      delete_comment
    end

    def delete_comment
      @comment.destroy
    end
  end
end
