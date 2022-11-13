# frozen_string_literal: true

module Customer
  # Class to manage interactions between logged in customer users and order comments
  class CommentOrdersController < ApplicationController
    before_action :set_order

    # Method to add a new comment
    # - POST /customer/comment_product_forms
    def create
      Customer::Comments::CommentOrderCreator.new(current_user, comment_order_form_params).call
      flash[:notice] = 'Comment was successfully added'
    rescue StandardError => e
      flash[:error] = e
    ensure
      redirect_to [:customer, @order]
    end

    private

    # Method to set strong paramas for order line form
    def comment_order_form_params
      params.require(:forms_comment_order_form).permit(:description, :rate_value, :order_id)
    end

    def set_order
      @order = Order.find(comment_order_form_params[:order_id])
    end
  end
end
