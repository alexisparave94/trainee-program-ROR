# frozen_string_literal: true

module Admin
  # Class to manage interactions between customer users and comments for a product or an order
  class CommentsController < ApplicationController
    before_action :authenticate_user!, only: %i[create]
    # before_action :set_comment
    before_action :authorize_action
    before_action :set_product

    def destroy
      # Admins::CommentDeleter.call(@comment)
      run Operations::Admin::Comments::Delete
      redirect_to @product, notice: 'Comment was successfully deleted'
    end

    def approve
      # Admins::CommentApprover.call(@comment)
      run Operations::Admin::Comments::Approve
      redirect_to @product, notice: 'Comment was successfully approved'
    end

    private

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    def authorize_action
      authorize @comment
    end
  end
end
