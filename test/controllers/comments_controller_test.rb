# frozen_string_literal: true

require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in @user = create(:user)
  end

  test 'should create a comment for a product' do
    product = create(:product)

    assert_difference('Comment.count') do
      post product_comments_url(product_id: product.id), params: { comment: { description: 'This is a comment', rate: 5.5 } }
    end

    assert_redirected_to product_url(product)
    assert_equal 'Comment was successfully added', flash[:notice]
  end

  test 'should create a comment for an order' do
    order = create(:order, user: @user, status: 'completed')

    assert_difference('Comment.count') do
      post order_comments_url(order_id: order.id), params: { comment: { description: 'This is a comment', rate: 8.5 } }
    end

    assert_redirected_to customer_order_url(order)
    assert_equal 'Comment was successfully added', flash[:notice]
  end

  test 'should response unprocessable entity' do
    order = create(:order, user: @user, status: 'completed')

    assert_no_difference('Comment.count') do
      post order_comments_url(order_id: order.id), params: { comment: { description: 'This is a comment', rate: -8.5 } }
    end

    assert_response :unprocessable_entity
  end
end
