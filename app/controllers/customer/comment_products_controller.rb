# frozen_string_literal: true

module Customer
  # Class to manage interactions between logged in customer users and comments
  class CommentProductsController < ApplicationController
    before_action :set_product

    # Method to add a new comment
    # - POST /customer/comment_products
    def create
      Customer::Comments::CommentProductCreator.call(current_user, comment_product_form_params)
      flash[:notice] = 'Comment was successfully added'
    rescue StandardError => e
      flash[:error] = e
    ensure
      redirect_to @product
    end

    private

    # Method to set strong params for comment product
    def comment_product_form_params
      params.require(:forms_comment_product_form).permit(:description, :rate_value, :product_id)
    end

    def set_product
      @product = Product.find(comment_product_form_params[:product_id])
    end
  end
end
