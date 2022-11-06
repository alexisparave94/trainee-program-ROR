# frozen_string_literal: true

require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test 'should create a comment for a product' do
    product = create(:product)
    # user = build(:user)
    user = create(:user)

    # post user_registration_url, params: { user: { first_name: user.first_name, last_name: user.last_name, email: user.email, password: user.password, password_confirmation: user.password_confirmation } }
    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    assert_difference('Comment.count') do
      post product_comments_url(product_id: product.id), params: { comment: { description: 'This is a comment', rate: 5.5 } }
    end

    assert_redirected_to product_url(product)
    assert_equal 'Comment was successfully added', flash[:notice]
  end

  test 'should create a comment for an order' do
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    order = create(:order, user:, status: 'completed')

    assert_difference('Comment.count') do
      post order_comments_url(order_id: order.id), params: { comment: { description: 'This is a comment', rate: 8.5 } }
    end

    assert_redirected_to customer_order_url(order)
    assert_equal 'Comment was successfully added', flash[:notice]
  end

  test 'should response unprocessable entity' do
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    order = create(:order, user:, status: 'completed')

    assert_no_difference('Comment.count') do
      post order_comments_url(order_id: order.id), params: { comment: { description: 'This is a comment', rate: -8.5 } }
    end

    assert_response :unprocessable_entity
  end
end
