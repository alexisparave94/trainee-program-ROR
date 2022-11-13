# frozen_string_literal: true

require 'test_helper'

class CommentProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in @user = create(:user)
  end

  test 'should create a comment for a product' do
    product = create(:product)

    assert_difference('Comment.count') do
      post customer_comment_products_url, params: { forms_comment_product_form: { description: 'This is a comment', rate_value: 5.5, product_id: product.id } }
    end

    assert_redirected_to product_url(product)
    assert_equal 'Comment was successfully added', flash[:notice]
  end
end
