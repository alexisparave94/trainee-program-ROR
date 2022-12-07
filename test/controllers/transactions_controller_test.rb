# frozen_string_literal: true

require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index for customer user' do
    sign_in @user = create(:user)

    create(:transaction, user: @user)

    get customer_transactions_url
    assert_response :success
  end

  test 'should get index for admin user' do
    sign_in @user = create(:user, role: 'admin')

    get admin_transactions_url
    assert_response :success
  end

  # API
  test 'sholud get all transactions of a customer user' do
    @user = create(:user)
    create(:transaction, user: @user)

    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    get api_v1_transactions_path, headers: { Authorization: token }

    assert_response :success
  end

  test 'sholud get all transactions of an admin user' do
    @user = create(:user, role: 'admin')
    create(:transaction, user: @user)

    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    get api_v1_admin_transactions_path, headers: { Authorization: token }

    assert_response :success
  end
end
