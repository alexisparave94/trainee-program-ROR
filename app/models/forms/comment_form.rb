# frozen_string_literal: true

module Forms
  # Class to manage Product Form model
  class CommentForm
    include ActiveModel::Model

    attr_accessor :description, :rate_value, :product_id, :current_user, :commentable, :rate

    # Validations
    validates :description, presence: { message: 'Must enter a description' }
    validates :rate_value, numericality: { in: 1..10, message: 'Rate must be between 1 and 10' }, allow_blank: true

    def initialize(attr = {}, current_user = nil)
      @current_user = current_user
      @commentable = Product.find(attr[:product_id]) if attr[:product_id]
      @rate = RateCommentSetter.call(@current_user, @commentable)
      @rate_value = @rate&.value
      super(attr)
    end

    def persisted?
      !@product.nil?
    end

    def id
      @product.nil? ? nil : @product.id
    end

    def create
      return false unless valid?

      if @rate
        @rate.update(value: rate_value) if rate_value
      else
        @rate = Rate.create(value: rate_value, user: current_user, rateable: @commentable)
      end
      @comment = Comment.create(description:, user: current_user, commentable: @commentable)
    end
  end
end
