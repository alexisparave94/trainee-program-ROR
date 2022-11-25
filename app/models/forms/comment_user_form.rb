# frozen_string_literal: true

module Forms
  # Class to manage comment user
  class CommentUserForm
    include ActiveModel::Model

    attr_accessor :description, :user, :commentable, :user_id

    # Validations
    validates :description, presence: { message: 'Must enter a content to comment' }
    validates :commentable, presence: { message: 'Must tell what user is going to be reviewed' }

    validate :cant_comment_yourself

    def initialize(attr = {}, user = nil)
      super(attr)
      @user = user
      @commentable = User.find(attr[:user_id])
    end

    def cant_comment_yourself
      return unless commentable.id == user.id

      errors.add(:user, 'You cannot add a comment for yourself')
    end
  end
end
