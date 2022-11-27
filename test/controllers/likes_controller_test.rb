# frozen_string_literal: true

require 'test_helper'

class LikesControllerTest < ActionDispatch::IntegrationTest
  include ActiveJob::TestHelper

  test 'should create a like for a product' do
    product = create(:product)
    sign_in create(:user)

    assert_difference('Like.count') do
      post customer_likes_url, params: { product_id: product.id }
    end

    assert_redirected_to products_path
    assert_equal 'Product liked successfully', flash[:notice]
  end

  test 'should report no authorized to create a like for a product' do
    product = create(:product)
    assert_no_difference('Like.count') do
      post customer_likes_url, params: { product_id: product.id }
    end

    assert_redirected_to root_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test 'should delete a like of a product' do
    sign_in user = create(:user)

    like = create(:like, user:)

    assert_difference('Like.count', -1) do
      delete customer_like_url(like)
    end

    assert_redirected_to products_path
    assert_equal 'Product disliked successfully', flash[:notice]
  end

  # Api

  test 'should create a like for a product api' do
    product = create(:product)
    @user = create(:user)
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    assert_difference('Like.count') do
      post api_v1_likes_url, params: { product_id: product.id }, headers: { Authorization: token }
    end

    assert_response :success
  end

  test 'should report unprocessable entity to like a product that already have been liked it by the user api' do
    product = create(:product)
    @user = create(:user)
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    post api_v1_likes_url, params: { product_id: product.id }, headers: { Authorization: token }
    assert_no_difference('Like.count') do
      post api_v1_likes_url, params: { product_id: product.id }, headers: { Authorization: token }
    end

    assert_response :unprocessable_entity
    assert_equal 'You have already liked it', response.parsed_body['error']
  end

  # Jobs
  test 'should enqueued update likes count job for like' do
    product = create(:product)
    @user = create(:user)
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    assert_enqueued_with(job: UpdateLikesCountJob, args: [product, 1]) do
      post api_v1_likes_url, params: { product_id: product.id }, headers: { Authorization: token }
    end

    perform_enqueued_jobs
    product.reload
    assert_equal product.likes_count, 2
  end

  test 'should enqueued update likes count job for delete like' do
    @user = create(:user)
    like = create(:like, user: @user)
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    assert_enqueued_with(job: UpdateLikesCountJob, args: [like.likeable, -1]) do
      delete api_v1_like_url(like), headers: { Authorization: token }
    end

    perform_enqueued_jobs
    like.likeable.reload
    assert_equal like.likeable.likes_count, 0
  end
end
