# frozen_string_literal: true

require 'test_helper'

class OrderLineFormsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = create(:product)
  end

  teardown do
    # When controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
    # Set virtual order to nil
    session[:virtual_order] = nil
    # Set order id to nil
    session[:order_id] = nil
  end

  test 'should get new' do
    get new_order_line_form_url, params: { product_id: @product.id }
    assert_response :success
  end

  test 'should create virtual order line' do
    post order_line_forms_url, params: { forms_order_line_form: { quantity: 2, price: @product.price, product_id: @product.id } }

    assert_redirected_to shopping_cart_path
    assert_equal 'Product was successfully added', flash[:notice]
    assert_equal 1, session[:virtual_order].size
  end

  test 'should get edit order line' do
    post order_line_forms_url, params: { forms_order_line_form: { quantity: 2, price: @product.price, product_id: @product.id } }

    line = session[:virtual_order].first

    get edit_order_line_form_url(id: line[:id], price: line[:price], quantity: line[:quantity])
    assert_response :success
  end

  test 'should update a virtual order line' do
    post order_line_forms_url, params: { forms_order_line_form: { quantity: 2, price: @product.price, product_id: @product.id } }

    line = session[:virtual_order].first

    patch order_line_form_url(id: line[:id]), params: { forms_order_line_form: { quantity: 2, product_id: @product.id } }
    assert_redirected_to shopping_cart_path
    assert_equal 'Quantity was successfully updated', flash[:notice]
  end

  test 'should get new order line for a customer user' do
    sign_in @user = create(:user)

    get new_customer_order_line_form_path, params: { product_id: @product.id }
    assert_response :success
  end

  test 'should create order line for customer user' do
    sign_in @user = create(:user)

    assert_difference('OrderLine.count') do
      post customer_order_line_forms_url, params: { forms_order_line_form: { quantity: 2, price: @product.price, product_id: @product.id } }
    end

    assert_redirected_to shopping_cart_path
    assert_equal 'Product was successfully added', flash[:notice]
  end

  test 'should get edit order line for a customer user' do
    sign_in @user = create(:user)

    order = create(:order, user: @user)
    order_line = create(:order_line, order:, product: @product, quantity: 2, price: 20.0)

    get edit_customer_order_line_form_url(order_line), params: { product_id: @product.id }
    assert_response :success
  end

  # Api
  test 'should create a new order and add the product for customer user api' do
    @user = create(:user)
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    assert_difference('OrderLine.count') do
      post api_v1_order_lines_url, params: { forms_order_line_form: { quantity: 2, product_id: @product.id } }, headers: { Authorization: token }
    end

    assert_response :success
    assert_equal 2, response.parsed_body['data']['order']['order_lines'][0]['quantity']
  end

  test 'should sum quantities of same product in an order for customer user api' do
    @user = create(:user)
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    post api_v1_order_lines_url, params: { forms_order_line_form: { quantity: 2, product_id: @product.id } }, headers: { Authorization: token }

    assert_no_difference('OrderLine.count') do
      post api_v1_order_lines_url, params: { forms_order_line_form: { quantity: 2, product_id: @product.id } }, headers: { Authorization: token }
    end

    assert_response :success
    assert_equal 4, response.parsed_body['data']['order']['order_lines'][0]['quantity']
  end
end
