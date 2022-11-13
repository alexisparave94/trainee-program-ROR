# frozen_string_literal: true

require 'test_helper'

class CommentOrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in @user = create(:user)
  end

  test 'should create a comment for an order' do
    order = create(:order, status: 'completed', user: @user)

    assert_difference('Comment.count') do
      post customer_comment_orders_url, params: { forms_comment_order_form: { description: 'This is a comment', rate_value: 5.5, order_id: order.id } }
    end

    assert_redirected_to customer_order_url(order)
    assert_equal 'Comment was successfully added', flash[:notice]
  end
end
