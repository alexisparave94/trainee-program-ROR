# frozen_string_literal: true

module Customer
  # Class to manage interactions between logged in customer users and comments
  class CommentOrderFormsController < ApplicationController
    # Method to add a new comment
    # - POST /customer/comment_product_forms
    def create
      @comment_order_form = Forms::CommentOrderForm.new(comment_order_form_params, current_user)
      if @comment_order_form.create
        redirect_to [:customer, @comment_order_form.commentable], notice: 'Comment was successfully added'
      else
        render 'customer/orders/show', status: :unprocessable_entity
      end
    end

    private

    # Method to set strong paramas for order line form
    def comment_order_form_params
      params.require(:forms_comment_order_form).permit(:description, :rate_value, :order_id)
    end
  end
end
