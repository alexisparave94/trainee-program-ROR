require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test 'should create a support user' do
    @user = create(:user, role: 'admin')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    assert_difference('User.count') do
      post api_v1_admin_users_url, params: { forms_user_form: { email: 'test@mail.com', password: '123456' } }, headers: { Authorization: token }
    end

    assert_response :success
  end

  test 'should soft delete a user' do
    @user = create(:user, role: 'admin')
    @user2 = create(:user, email: 'test1@mail.com')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    patch api_v1_admin_user_soft_delete_url(@user2), headers: { Authorization: token }

    assert_response :success
  end

  test 'should restore a user' do
    @user = create(:user, role: 'admin')
    @user2 = create(:user, email: 'test1@mail.com')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    patch api_v1_admin_user_soft_delete_url(@user2), headers: { Authorization: token }

    patch api_v1_admin_user_restore_url(@user2), headers: { Authorization: token }

    assert_response :success
  end
end
