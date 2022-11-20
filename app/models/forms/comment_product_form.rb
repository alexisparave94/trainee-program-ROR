# frozen_string_literal: true

module Forms
  # Class to manage Product Form model
  class CommentProductForm
    include ActiveModel::Model

    attr_accessor :description, :rate_value, :product_id, :user, :commentable, :rate

    # Validations
    validates :description, presence: { message: 'Must enter a content to comment' }
    validates :rate_value, numericality: { in: 1..10, message: 'Rate must be between 1 and 10' }, allow_blank: true

    def initialize(attr = {}, user = nil)
      super(attr)
      @user = user
      @commentable = Product.find(attr[:product_id])
      @rate = RateCommentSetter.call(@user, @commentable)
    end
  end
end
