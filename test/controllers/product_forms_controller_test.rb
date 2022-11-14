# frozen_string_literal: true

require 'test_helper'

class ProductFormsControllerTest < ActionDispatch::IntegrationTest
  test 'should get new product' do
    sign_in @user = create(:user, role: 'admin')

    get new_admin_product_form_path
    assert_response :success
  end

  test 'should report not authorized to get new product' do
    sign_in @user = create(:user)

    get new_admin_product_form_path
    assert_redirected_to root_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test 'should create a product' do
    sign_in @user = create(:user, role: 'admin')

    product = build(:product)
    assert_difference('Product.count') do
      post admin_product_forms_path, params: { forms_product_form: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: product.stock } }
    end

    assert_redirected_to root_url
    assert_equal 'Product was successfully created', flash[:notice]
  end

  test 'should report not authorized to create a product' do
    sign_in @user = create(:user, role: 'support')

    product = build(:product)
    assert_no_difference('Product.count') do
      post admin_product_forms_path, params: { forms_product_form: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: product.stock } }
    end

    assert_redirected_to root_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test 'should get edit product' do
    sign_in @user = create(:user, role: 'admin')

    product = create(:product)

    get edit_admin_product_form_path(id: product.id)
    assert_response :success
  end

  test 'should update a product' do
    sign_in @user = create(:user, role: 'admin')

    product = create(:product)

    patch admin_product_form_path(id: product.id), params: { forms_product_form: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: product.stock } }

    assert_redirected_to root_path
    assert_equal 'Product was successfully updated', flash[:notice]
  end
end
