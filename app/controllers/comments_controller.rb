# frozen_string_literal: true

# Class to manage Coments Controller
class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

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

  def comment_params
    params.require(:comment).permit(:description, :rate)
  end

  def set_commentable
    @commentable = Product.find(params[:product_id]) if params[:product_id]
    @commentable = Order.find(params[:order_id]) if params[:order_id]
    @comment.commentable = @commentable
  end

  def redirect_to_show_product
    redirect_to @commentable, notice: 'Comment was successfully added' if params[:product_id]
  end

  def redirect_to_show_order
    redirect_to [:customer, @commentable], notice: 'Comment was successfully added' if params[:order_id]
  end
end
