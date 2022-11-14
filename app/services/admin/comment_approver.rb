# frozen_string_literal: true

module Admin
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
