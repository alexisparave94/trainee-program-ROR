# frozen_string_literal: true

module Forms
  # Class to manage Product Form model
  class CommentOrderForm
    include ActiveModel::Model

    attr_accessor :description, :rate_value, :order_id, :current_user, :commentable, :rate

    # Validations
    validates :description, presence: { message: 'Must enter a description' }
    validates :rate_value, numericality: { in: 1..10, message: 'Rate must be between 1 and 10' }, allow_blank: true

    def initialize(attr = {}, current_user = nil)
      super(attr)
      @current_user = current_user
      @commentable = Order.find(attr[:order_id]) if attr[:order_id]
      @rate = RateCommentSetter.call(@current_user, @commentable)
    end

    def create
      return false unless valid?

      if @rate
        @rate.update(value: rate_value) unless rate_value.empty?
      else
        @rate = Rate.create(value: rate_value, user: current_user, rateable: @commentable)
      end
      @comment = Comment.create(description:, user: current_user, commentable: @commentable, status: 'approved')
    end
  end
end
