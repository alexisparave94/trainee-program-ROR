class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    @commentable = Product.find(params[:product_id]) if params[:product_id]

    @commentable = Order.find(params[:order_id]) if params[:order_id]
    @comment.commentable = @commentable

    if @comment.save
      redirect_to @commentable, notice: 'Comment was successfully added' if params[:product_id]
      redirect_to [:customer, @commentable], notice: 'Comment was successfully added' if params[:order_id]
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
end
