# frozen_string_literal: true

module Admins
  # Service object to approved a comment
  class CommentApprover < ApplicationService
    def initialize(comment)
      @comment = comment
      super()
    end

    def call
      approve_comment
      @comment
    end

    def approve_comment
      @comment.update(status: 'approved')
    end
  end
end
