# frozen_string_literal: true

# Class to manage interactions between customer users and comments for a product or am order
class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  # Method to create add a comment to a product or an order
  # - POST /products/:product_id/comments || /orders/:order_id/comments
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    set_commentable

    if @comment.save
      redirect_to_show_product
      redirect_to_show_order
    elsif params[:product_id]
      render 'products/show', status: :unprocessable_entity
    elsif params[:order_id]
      render 'customer/orders/show', status: :unprocessable_entity
    end
  end

  private

  # Method to set strong paramas for comment
  def comment_params
    params.require(:comment).permit(:description, :rate)
  end

  # Method to set a specific commentable object (order or product)
  def set_commentable
    @commentable = Product.find(params[:product_id]) if params[:product_id]
    @commentable = Order.find(params[:order_id]) if params[:order_id]
    @comment.commentable = @commentable
  end

  # Method to redirect request to show product
  def redirect_to_show_product
    redirect_to @commentable, notice: 'Comment was successfully added' if params[:product_id]
  end

  # Method to redirect request to show customer order  
  def redirect_to_show_order
    redirect_to [:customer, @commentable], notice: 'Comment was successfully added' if params[:order_id]
  end
end
