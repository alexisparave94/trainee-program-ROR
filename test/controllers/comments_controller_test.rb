# frozen_string_literal: true

require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  test 'should delete a comment of a product' do
    sign_in @user = create(:user, role: 'admin')

    product = create(:product)

    post customer_comment_products_url, params: { forms_comment_product_form: { description: 'This is a comment', rate_value: 5.5, product_id: product.id } }

    comment = product.comments.reload.first

    assert_difference('Comment.count', -1) do
      delete admin_comment_url(comment), params: { product_id: product.id }
    end

    assert_redirected_to product_url(product)
    assert_equal 'Comment was successfully deleted', flash[:notice]
  end

  test 'should approve a comment of a product' do
    sign_in @user = create(:user, role: 'admin')

    product = create(:product)

    post customer_comment_products_url, params: { forms_comment_product_form: { description: 'This is a comment', rate_value: 5.5, product_id: product.id } }

    comment = product.comments.reload.first

    patch admin_comments_approve_url, params: { id: comment.id, product_id: product.id }

    assert_redirected_to product_url(product)
    assert_equal 'Comment was successfully approved', flash[:notice]
  end

  # API
  test 'should delete a comment of a user api' do
    @user = create(:user)

    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    user2 = create(:user, email: 'xxx@mail.com')

    post api_v1_comment_users_url, params: { forms_comment_user_form: { description: 'This is a comment', user_id: user2.id } }, headers: { Authorization: token }

    comment = user2.received_comments.reload.first

    user_admin = create(:user, role: 'admin', email: 'admin@mail.com')
    post api_v1_sign_in_url, params: { email: user_admin.email, password: user_admin.password }

    token = response.parsed_body['data']['session']['token']

    assert_difference('Comment.count', -1) do
      delete api_v1_admin_comment_path(comment), headers: { Authorization: token }
    end

    assert_response :no_content
  end

  test 'should approve a comment of a user api' do
    @user = create(:user)

    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    user2 = create(:user, email: 'xxx@mail.com')

    post api_v1_comment_users_url, params: { forms_comment_user_form: { description: 'This is a comment', user_id: user2.id } }, headers: { Authorization: token }

    comment = user2.received_comments.reload.first

    user_admin = create(:user, role: 'admin', email: 'admin@mail.com')
    post api_v1_sign_in_url, params: { email: user_admin.email, password: user_admin.password }

    token = response.parsed_body['data']['session']['token']

    patch approve_api_v1_admin_comment_path(comment), headers: { Authorization: token }

    assert_response :success
  end
end
