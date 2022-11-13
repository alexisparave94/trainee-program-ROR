# frozen_string_literal: true

module Customer
  module Comments
    # Service object to like a product
    class CommentProductCreator < ApplicationService
      class NotValidEntryRecord < StandardError; end

      def initialize(user, params)
        @user = user
        @params = params
        @commentable = Product.find(params[:product_id])
        @rate = RateCommentSetter.call(@user, @commentable)
        super()
      end

      def call
        @comment_product_form = Forms::CommentProductForm.new(@params)
        raise(NotValidEntryRecord, parse_errors) unless @comment_product_form.valid?

        if @rate
          @rate.update(value: @comment_product_form.rate_value) unless @comment_product_form.rate_value.empty?
        else
          Rate.create(value: @comment_product_form.rate_value, user: @user, rateable: @commentable)
        end
        @comment = Comment.create(description: @comment_product_form.description, user: @user, commentable: @commentable)
      end

      private

      def parse_errors
        @comment_order_form.errors.messages.map { |_key, error| error }.join(', ')
      end
    end
  end
end
