# frozen_string_literal: true

module Customer
  # Class to manage interactions between logged in customer users and comments
  class CommentFormsController < ApplicationController
    # Method to add a new product (order line) to shopping cart
    # - POST /customer/order_line_forms
    def create
      @comment_form = Forms::CommentForm.new(comment_form_params, current_user)
      if @comment_form.create
        redirect_to @comment_form.commentable, notice: 'Comment was successfully added'
      else
        render 'products/show', status: :unprocessable_entity
      end
    end

    private

    # Method to set strong paramas for order line form
    def comment_form_params
      params.require(:forms_comment_form).permit(:description, :rate_value, :product_id)
    end
  end
end
