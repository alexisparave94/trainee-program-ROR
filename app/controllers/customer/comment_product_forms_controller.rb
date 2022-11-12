# frozen_string_literal: true

module Customer
  # Class to manage interactions between logged in customer users and comments
  class CommentProductFormsController < ApplicationController
    # Method to add a new comment
    # - POST /customer/comment_product_forms
    def create
      @comment_product_form = Forms::CommentProductForm.new(comment_product_form_params, current_user)
      if @comment_product_form.create
        redirect_to @comment_product_form.commentable, notice: 'Comment was successfully added'
      else
        render 'products/show', status: :unprocessable_entity
      end
    end

    private

    # Method to set strong paramas for order line form
    def comment_product_form_params
      params.require(:forms_comment_product_form).permit(:description, :rate_value, :product_id)
    end
  end
end
