# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  test 'should create a like for a product' do
    product = create(:product)
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    assert_difference('Like.count') do
      post customer_likes_url, params: { product_id: product.id }
    end

    assert_redirected_to products_path
    assert_equal 'Product liked successfully', flash[:notice]
  end

  test 'should delete a like of a product' do
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    like = create(:like, user:)

    assert_difference('Like.count', -1) do
      delete customer_like_url(like)
    end

    assert_redirected_to products_path
    assert_equal 'Product disliked successfully', flash[:notice]
  end
end
