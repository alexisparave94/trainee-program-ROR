# frozen_string_literal: true

module Admin
  # Service object to approved a comment
  class CommentApprover < ApplicationService
    def initialize(comment)
      @comment = comment
      super()
    end

    def call
      approve_comment
    end

    def approve_comment
      @comment.update(status: 'approved')
    end
  end
end
