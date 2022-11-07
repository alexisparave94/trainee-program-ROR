# frozen_string_literal: true

require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in @user = create(:user)
  end

  test 'should get index of orders of a user' do
    get customer_orders_url
    assert_response :success
  end

  test 'should show an specific order of a user' do
    order = create(:order, user: @user, status: 'completed')

    get customer_order_url(order)
    assert_response :success
  end

  test 'should report not authorized to show an specific order of another user' do
    @user2 = create(:user, first_name: 'Carlos', last_name: 'Perez', email: 'carlos@mail.com', password: '123456')

    order = create(:order, user: @user2, status: 'completed')

    get customer_order_url(order)
    assert_redirected_to root_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test 'should update an order to completed' do
    product = create(:product)

    order = create(:order, user: @user, status: 'pending')
    create(:order_line, order:, product:, price: product.price, quantity: 5)

    patch customer_order_url(order)

    order.reload
    product.reload

    assert_redirected_to products_path
    assert_equal 'Thanks for buy', flash[:notice]
    assert_equal order.status, 'completed'
    assert_equal order.total, 100
    assert_equal product.stock, 5
  end
end
