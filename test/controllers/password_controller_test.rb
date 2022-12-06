# frozen_string_literal: true

require 'test_helper'

class PasswordControllerTest < ActionDispatch::IntegrationTest
  test 'should get form of forgot password' do
    get forgot_password_url
    assert_response :success
  end

  test 'should send instructions to reset a password' do
    user = create(:user)

    post reset_password_url, params: { user: { email: user.email } }
    assert_response :success
    assert_equal 'Instructions sent', flash[:notice]
  end

  test 'should redirect to forgot a password' do
    post reset_password_url, params: { user: { email: 'no_exist_mail@mail.com' } }
    assert_redirected_to forgot_password_url
  end
end
