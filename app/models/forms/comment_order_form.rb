# frozen_string_literal: true

module Forms
  # Class to manage Product Form model
  class CommentOrderForm
    include ActiveModel::Model

    attr_accessor :description, :rate_value, :order_id, :user, :commentable, :rate

    # Validations
    validates :description, presence: { message: 'Must enter a content to comment' }
    validates :rate_value, numericality: { in: 1..10, message: 'Rate must be between 1 and 10' }, allow_blank: true

    def initialize(attr = {}, user = nil)
      super(attr)
      @user = user
      @commentable = Order.find(attr[:order_id]) if attr[:order_id]
      @rate = RateCommentSetter.call(@user, @commentable)
    end
  end
end
