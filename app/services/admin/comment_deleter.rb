module Admin
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
