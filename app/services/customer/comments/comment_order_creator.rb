# frozen_string_literal: true

module Customer
  module Comments
    # Service object to like a product
    class CommentOrderCreator < ApplicationService
      def initialize(user, params)
        @user = user
        @params = params
        @commentable = Order.find(params[:order_id])
        @rate = RateCommentSetter.call(@user, @commentable)
        super()
      end

      def call
        @comment_order_form = Forms::CommentOrderForm.new(@params)
        raise(StandardError, parse_errors) unless @comment_order_form.valid?

        if @rate
          @rate.update(value: @comment_order_form.rate_value) unless @comment_order_form.rate_value.empty?
        else
          Rate.create(value: @comment_order_form.rate_value, user: @user, rateable: @commentable)
        end
        @comment = Comment.create(description: @comment_order_form.description, user: @user, commentable: @commentable)
      end

      private

      def parse_errors
        @comment_order_form.errors.messages.map { |_key, error| error }.join(', ')
      end
    end
  end
end
