class Customer::LikesController < ApplicationController
  def create
    @product = Product.find(params[:product_id])
    @like = Like.new(user: current_user, product: @product)
    @like.save
    redirect_to products_path, notice: 'Product liked successfully'
  end

  def destroy
    @like = Like.find(params[:id])
    @like.destroy
    redirect_to products_path, notice: 'Product disliked successfully'
  end
end
