# frozen_string_literal: true

require 'test_helper'

class CheckoutPayControllerTest < ActionDispatch::IntegrationTest
  test 'should create a session' do
    @product = create(:product)
    sign_in @user = create(:user)

    post customer_order_line_forms_url, params: { forms_order_line_form: { quantity: 2, price: @product.price, product_id: @product.id } }

    post checkout_pay_url
    assert_response 302
  end
end
