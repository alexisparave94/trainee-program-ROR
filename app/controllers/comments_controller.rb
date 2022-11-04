class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[create]

  def create
    @product = Product.find(params[:product_id])
    @comment = Comment.new(comment_parmas)
    @comment.user = current_user
    @comment.commentable = @product
    if @comment.save
      redirect_to @product, notice: 'Comment was successfully added'
    else
      render 'products/show', status: :unprocessable_entity
    end
  end

  private

  def comment_parmas
    params.require(:comment).permit(:description, :rate)
  end
end
