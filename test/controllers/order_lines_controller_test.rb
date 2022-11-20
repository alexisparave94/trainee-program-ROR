# frozen_string_literal: true

require 'test_helper'

class OrderLinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = create(:product)
  end

  teardown do
    # When controller is using cache it may be a good idea to reset it afterwards
    Rails.cache.clear
    # Set virtual order to nil
    session[:virtual_order] = nil
    # Set order id to nil
    session[:order_id] = nil
  end

  test 'should delete an order line' do
    post order_line_forms_url, params: { forms_order_line_form: { quantity: 2, price: @product.price, product_id: @product.id } }

    line = session[:virtual_order].first

    delete order_line_url(id: line[:id])
    assert_redirected_to shopping_cart_path
    assert_equal 'Product was successfully deleted', flash[:notice]
    assert_nil session[:virtual_order]
  end

  test 'should delete order line for customer user' do
    sign_in @user = create(:user)

    order = create(:order, user: @user)
    order_line = create(:order_line, order:, product: @product, quantity: 2, price: 20.0)

    assert_difference('OrderLine.count', -1) do
      delete customer_order_line_url(order_line)
    end

    assert_redirected_to shopping_cart_path
    assert_equal 'Line was successfully deleted', flash[:notice]
  end
end
