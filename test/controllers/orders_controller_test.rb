# frozen_string_literal: true

require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  test 'should get index of orders of a user' do
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    get customer_orders_url
    assert_response :success
  end

  test 'should show an specific order of a user' do
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    order = create(:order, user:, status: 'completed')

    get customer_order_url(order)
    assert_response :success
  end

  test 'should buy an order' do
    product = create(:product)
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    order = create(:order, user:, status: 'pending')
    create(:order_line, order:, product:, price: product.price, quantity: 5)

    patch customer_order_url(order)
    assert_redirected_to products_path
    assert_equal 'Thanks for buy', flash[:notice]
  end
end
