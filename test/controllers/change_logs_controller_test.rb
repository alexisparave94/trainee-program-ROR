# frozen_string_literal: true

require 'test_helper'

class ChangeLogsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    user = create(:user, role: 'admin')

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    get admin_change_logs_url
    assert_response :success
  end

  test 'should report not authorized to get index' do
    user = create(:user)

    post new_user_session_url, params: { user: { email: user.email, password: user.password } }

    get admin_change_logs_url

    assert_redirected_to root_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end
end
