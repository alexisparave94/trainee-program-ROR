# frozen_string_literal: true

require 'test_helper'

class OrderLinesControllerTest < ActionDispatch::IntegrationTest
  # called after every single test
  # teardown do
  #   # When controller is using cache it may be a good idea to reset it afterwards
  #   Rails.cache.clear
  #   # Set virtual oreder to nil
  #   session[:virtual_order] = nil
  # end

  # test 'should get new' do
  #   product = create(:product)

  #   get new_order_line_url, params: { product_id: product.id }
  #   assert_response :success
  # end

  test 'should create virtual order line' do
    product = create(:product)

    post order_lines_url, params: { order_line: { quantity: 2, price: product.price, product_id: product.id } }

    assert_redirected_to shopping_cart_path
    assert_equal 'Line was successfully added to shopping', flash[:notice]
    assert_equal 1, session[:virtual_order].size
  end

  # test 'should response for create unprocessable entity' do
  #   product = create(:product)
  #   post order_lines_url, params: { order_line: { quantity: -2, price: product.price, product_id: product.id } }

  #   assert_response :unprocessable_entity
  # end

  # test 'should get edit order line' do
  #   product = create(:product)

  #   post order_lines_url, params: { order_line: { quantity: 2, price: product.price, product_id: product.id } }

  #   line = session[:virtual_order].first

  #   get edit_order_line_url(id: line[:id])
  #   assert_response :success
  # end

  test 'should update an order line' do
    product = create(:product)

    post order_lines_url, params: { order_line: { quantity: 2, price: product.price, product_id: product.id } }

    line = session[:virtual_order].first

    patch order_line_url(id: line[:id]), params: { order_line: { quantity: 2, product_id: product.id } }
    assert_redirected_to shopping_cart_path
    assert_equal 'Line was successfully updated', flash[:notice]
  end

  # test 'response for update unprocessable entity' do
  #   product = create(:product)

  #   post order_lines_url, params: { order_line: { quantity: 2, price: product.price, product_id: product.id } }

  #   line = session[:virtual_order].first

  #   patch order_line_url(id: line[:id]), params: { order_line: { quantity: -2, product_id: product.id } }

  #   assert_response :unprocessable_entity
  # end

  # test 'should delete an order line' do
  #   product = create(:product)

  #   post order_lines_url, params: { order_line: { quantity: 2, price: product.price, product_id: product.id } }

  #   line = session[:virtual_order].first

  #   delete order_line_url(id: line[:id])
  #   assert_redirected_to shopping_cart_path
  #   assert_equal 'Line was successfully deleted', flash[:notice]
  #   assert_nil session[:virtual_order]
  # end

  test 'should get new order line for a customer user' do
    product = create(:product)
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    get new_customer_order_line_url, params: { product_id: product.id }
    assert_response :success
  end

  test 'should report not authorized to get new order line for a customer user' do
    product = create(:product)
    user = create(:user, role: 'admin')

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    get new_customer_order_line_url, params: { product_id: product.id }

    assert_redirected_to root_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test 'should create order line for customer user' do
    product = create(:product)
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    assert_difference('OrderLine.count') do
      post customer_order_lines_url, params: { order_line: { quantity: 2, price: product.price, product_id: product.id } }
    end

    assert_redirected_to shopping_cart_path
    assert_equal 'Line was successfully added', flash[:notice]
  end

  test 'should response for create order line unprocessable entity' do
    product = create(:product)
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    assert_no_difference('OrderLine.count') do
      post customer_order_lines_url, params: { order_line: { quantity: -2, price: product.price, product_id: product.id } }
    end

    assert_response :unprocessable_entity
  end

  test 'should report not authorized to create order line for a customer user' do
    product = create(:product)
    user = create(:user, role: 'admin')

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    assert_no_difference('OrderLine.count') do
      post customer_order_lines_url, params: { order_line: { quantity: 2, price: product.price, product_id: product.id } }
    end

    assert_redirected_to root_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test 'should get edit order line for a customer user' do
    product = create(:product)
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    order = create(:order, user:)
    order_line = create(:order_line, order:, product:, quantity: 2, price: 20.0)

    get edit_customer_order_line_url(order_line)
    assert_response :success
  end

  test 'should report not authorized to get edit order line for a customer user' do
    product = create(:product)
    user = create(:user, role: 'admin')

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    order = create(:order, user:)
    order_line = create(:order_line, order:, product:, quantity: 2, price: 20.0)

    get edit_customer_order_line_url(order_line)

    assert_redirected_to root_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test 'should update order line for customer user' do
    product = create(:product)
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    order = create(:order, user:)
    order_line = create(:order_line, order:, product:, quantity: 2, price: 20.0)

    patch customer_order_line_url(id: order_line.id), params: { order_line: { quantity: 4, product_id: product.id } }

    assert_redirected_to shopping_cart_path
    assert_equal 'Line was successfully updated', flash[:notice]
  end

  test 'should response for update order line unprocessable entity' do
    product = create(:product)
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    order = create(:order, user:)
    order_line = create(:order_line, order:, product:, quantity: 2, price: 20.0)

    patch customer_order_line_url(id: order_line.id), params: { order_line: { quantity: -4, product_id: product.id } }

    assert_response :unprocessable_entity
  end

  test 'should report not authorized to edit order line for a customer user' do
    product = create(:product)
    user = create(:user, role: 'admin')

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    order = create(:order, user:)
    order_line = create(:order_line, order:, product:, quantity: 2, price: 20.0)

    patch customer_order_line_url(id: order_line.id), params: { order_line: { quantity: 4, product_id: product.id } }

    assert_redirected_to root_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test 'should delete order line for customer user' do
    product = create(:product)
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    order = create(:order, user:)
    order_line = create(:order_line, order:, product:, quantity: 2, price: 20.0)

    assert_difference('OrderLine.count', -1) do
      delete customer_order_line_url(order_line)
    end

    assert_redirected_to shopping_cart_path
    assert_equal 'Line was successfully deleted', flash[:notice]
  end

  test 'should report not authorized to delete order line for a customer user' do
    product = create(:product)
    user = create(:user, role: 'admin')

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    order = create(:order, user:)
    order_line = create(:order_line, order:, product:, quantity: 2, price: 20.0)

    assert_no_difference('OrderLine.count') do
      delete customer_order_line_url(order_line)
    end

    assert_redirected_to root_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end
end
