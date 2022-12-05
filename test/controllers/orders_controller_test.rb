# frozen_string_literal: true

require 'test_helper'

class OrdersControllerTest < ActionDispatch::IntegrationTest
  # setup do
  #   sign_in @user = create(:user)
  # end

  test 'should get index of orders of a user' do
    sign_in @user = create(:user)

    get customer_orders_url
    assert_response :success
  end

  test 'should show an specific order of a user' do
    sign_in @user = create(:user)

    order = create(:order, user: @user, status: 'completed')

    get customer_order_url(order)
    assert_response :success
  end

  test 'should report not authorized to show an specific order of another user' do
    sign_in @user = create(:user)

    @user2 = create(:user, first_name: 'Carlos', last_name: 'Perez', email: 'carlos@mail.com', password: '123456')

    order = create(:order, user: @user2, status: 'completed')

    get customer_order_url(order)
    assert_redirected_to root_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test 'should update an order to completed' do
    sign_in @user = create(:user)

    product = create(:product)

    order = create(:order, user: @user, status: 'pending')
    create(:order_line, order:, product:, price: product.price, quantity: 5)

    patch customer_order_url(order)

    order.reload
    product.reload

    assert_redirected_to products_path
    assert_equal 'Thanks for buy', flash[:notice]
    assert_equal order.status, 'completed'
    assert_equal product.stock, 5
  end

  # Api section

  test 'should show orders of a customer user api' do
    @user = create(:user)
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']
    @order = create(:order, user: @user, status: 'completed')

    get api_v1_orders_url, headers: { Authorization: token }
    assert_response :success
  end

  test 'should checkout an order for customer user api' do
    @product = create(:product)
    @user = create(:user)
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    post api_v1_order_lines_url, params: { forms_order_line_form: { quantity: 2, product_id: @product.id } }, headers: { Authorization: token }
    order_id = response.parsed_body['data']['order']['id']

    get api_v1_checkout_url, params: { order_id: }, headers: { Authorization: token }

    assert_response :success
  end

  test 'should report an unprocessable entity if there is enough stock for customer user api' do
    @product = create(:product)
    @user = create(:user)
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    post api_v1_order_lines_url, params: { forms_order_line_form: { quantity: 20, product_id: @product.id } }, headers: { Authorization: token }
    order_id = response.parsed_body['data']['order']['id']

    get api_v1_checkout_url, params: { order_id: }, headers: { Authorization: token }

    assert_response :unprocessable_entity
    assert_equal 'Not enough stock', response.parsed_body['message']
  end

  # test 'should report an unprocessable entity if the purchase has been completed for customer user api' do
  #   @product = create(:product)
  #   @user = create(:user)
  #   post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

  #   token = response.parsed_body['data']['session']['token']

  #   post api_v1_order_lines_url, params: { forms_order_line_form: { quantity: 2, product_id: @product.id } }, headers: { Authorization: token }
  #   order_id = response.parsed_body['data']['order']['id']

  #   get api_v1_checkout_url, params: { order_id: }, headers: { Authorization: token }
  #   get api_v1_checkout_url, params: { order_id: }, headers: { Authorization: token }

  #   assert_response :unprocessable_entity
  #   assert_equal 'The purchase has been completed', response.parsed_body['error']
  # end

  # test 'should enqueued notify last user liked job' do
  #   @user = create(:user)
  #   like = create(:like, user: @user)
  #   post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

  #   token = response.parsed_body['data']['session']['token']

  #   post api_v1_order_lines_url, params: { forms_order_line_form: { quantity: 7, product_id: like.likeable.id } }, headers: { Authorization: token }
  #   order_id = response.parsed_body['data']['order']['id']

  #   assert_enqueued_with(job: NotifyLastUserLikedJob, args: [{ email: @user.email, products: [like.likeable] }]) do
  #     get api_v1_checkout_url, params: { order_id: }, headers: { Authorization: token }
  #   end
  # end
end
