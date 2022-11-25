# frozen_string_literal: true

module Customer
  module Comments
    # Service object to create a comment for a user
    class CommentUserCreator < ApplicationService
      def initialize(user, params)
        @user = user
        @params = params
        @commentable = User.find(params[:user_id])
        super()
      end

      def call
        @comment_user_form = Forms::CommentUserForm.new(@params, @user)
        raise(NotValidEntryRecord, parse_errors_api) unless @comment_user_form.valid?

        @comment = Comment.create(description: @comment_user_form.description, user: @user,
                                  commentable: @commentable)
      end

      def parse_errors_api
        @comment_user_form.errors.messages
      end
    end
  end
end
