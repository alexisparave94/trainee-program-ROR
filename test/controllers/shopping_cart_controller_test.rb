# frozen_string_literal: true

require 'test_helper'

class ShoppingCartControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = create(:product)
  end

  test 'should get shopping cart for not logged in user' do
    post order_line_forms_url, params: { forms_order_line_form: { quantity: 2, price: @product.price, product_id: @product.id } }

    get shopping_cart_url
    assert_response :success
    assert_equal 1, session[:virtual_order].size
  end

  test 'should get shopping cart for logged in user' do
    sign_in @user = create(:user)

    order = create(:order, user: @user)
    create(:order_line, order:, product: @product, quantity: 2, price: 20.0)

    get shopping_cart_url
    assert_response :success
  end

  test 'should empty shopping cart no logged in user' do
    post order_line_forms_url, params: { forms_order_line_form: { quantity: 2, price: @product.price, product_id: @product.id } }

    get empty_cart_url

    assert_redirected_to shopping_cart_path
    assert_nil session[:virtual_order]
  end

  test 'should empty shopping cart with a logged in user' do
    sign_in @user = create(:user)

    post customer_order_line_forms_url, params: { forms_order_line_form: { quantity: 2, price: @product.price, product_id: @product.id } }

    assert_difference('OrderLine.count', -1) do
      get customer_empty_cart_path(order_id: session[:order_id])
    end

    assert_redirected_to shopping_cart_path
    assert_equal 'Shopping cart has been emptied successfully', flash[:notice]
  end

  test 'should redirect to products when try to empty shopping cart with a logged in user' do
    sign_in @user = create(:user)

    post customer_order_line_forms_url, params: { forms_order_line_form: { quantity: 2, price: @product.price, product_id: @product.id } }

    get customer_empty_cart_path(order_id: nil)

    assert_redirected_to products_path
  end

  test 'should redirect to products when try to get an empty shopping cart with a no logged in user' do
    sign_in @user = create(:user)

    get shopping_cart_path

    assert_redirected_to products_path
  end

  # test 'should get checkout order lines session checkout must be empty' do
  #   sign_in @user = create(:user)

  #   post customer_order_line_forms_url, params: { forms_order_line_form: { quantity: 2, price: @product.price, product_id: @product.id } }

  #   get customer_checkout_path
  #   assert_redirected_to shopping_cart_path
  #   assert_equal true, session[:checkout].empty?
  # end

  # test 'should get checkout order lines session checkout must not be empty' do
  #   sign_in @user = create(:user)

  #   post customer_order_line_forms_url, params: { forms_order_line_form: { quantity: 20, price: @product.price, product_id: @product.id } }

  #   get customer_checkout_path
  #   assert_redirected_to shopping_cart_path
  #   assert_equal 1, session[:checkout].size
  # end
end
