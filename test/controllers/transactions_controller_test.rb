require 'test_helper'

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    sign_in @user = create(:user, role: 'admin')

    get admin_transactions_url
    assert_response :success
  end
end
