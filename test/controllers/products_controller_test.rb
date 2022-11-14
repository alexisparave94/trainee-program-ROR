# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index od products' do
    get products_url
    assert_response :success
  end

  test 'should show a product' do
    product = create(:product)
    get product_url(product)
    assert_response :success
  end

  # test 'should get new product' do
  #   sign_in @user = create(:user, role: 'admin')

  #   get new_admin_product_url
  #   assert_response :success
  # end

  # test 'should report not authorized to get new product' do
  #   sign_in @user = create(:user)

  #   get new_admin_product_url
  #   assert_redirected_to root_url
  #   assert_equal 'You are not authorized to perform this action.', flash[:alert]
  # end

  # test 'should create a product' do
  #   sign_in @user = create(:user, role: 'admin')

  #   product = build(:product)
  #   assert_difference('Product.count') do
  #     post admin_products_url, params: { product: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: product.stock } }
  #   end

  #   assert_redirected_to products_path
  #   assert_equal 'Product was successfully created', flash[:notice]
  # end

  # test 'should response for create unprocessable entity' do
  #   sign_in @user = create(:user, role: 'admin')

  #   product = build(:product)
  #   assert_no_difference('Product.count') do
  #     post admin_products_url, params: { product: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: -10 } }
  #   end

  #   assert_response :unprocessable_entity
  # end

  # test 'should report not authorized to create a product' do
  #   sign_in @user = create(:user)

  #   product = build(:product)
  #   assert_no_difference('Product.count') do
  #     post admin_products_url, params: { product: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: product.stock } }
  #   end

  #   assert_redirected_to root_url
  #   assert_equal 'You are not authorized to perform this action.', flash[:alert]
  # end

  # test 'should get edit product' do
  #   sign_in @user = create(:user, role: 'admin')

  #   product = create(:product)

  #   get edit_admin_product_url(id: product.id)
  #   assert_response :success
  # end

  # test 'should report not authorized to get edit product' do
  #   sign_in @user = create(:user)

  #   product = create(:product)

  #   get edit_admin_product_url(id: product.id)
  #   assert_redirected_to root_url
  #   assert_equal 'You are not authorized to perform this action.', flash[:alert]
  # end

  # test 'should update a product' do
  #   sign_in @user = create(:user, role: 'admin')

  #   product = create(:product)

  #   patch admin_product_url(id: product.id), params: { product: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: product.stock } }

  #   assert_redirected_to products_path
  #   assert_equal 'Product was successfully updated', flash[:notice]
  # end

  # test 'should response for update unprocessable entity' do
  #   sign_in @user = create(:user, role: 'admin')

  #   product = create(:product)

  #   patch admin_product_url(id: product.id), params: { product: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: -10 } }

  #   assert_response :unprocessable_entity
  # end

  # test 'should report not authorized to update a product' do
  #   sign_in @user = create(:user)

  #   product = create(:product)

  #   patch admin_product_url(id: product.id), params: { product: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: product.stock } }

  #   assert_redirected_to root_url
  #   assert_equal 'You are not authorized to perform this action.', flash[:alert]
  # end

  # test 'should delete a product' do
  #   sign_in @user = create(:user, role: 'admin')

  #   product = create(:product)

  #   assert_difference('Product.count', -1) do
  #     delete admin_product_url(product)
  #   end

  #   assert_redirected_to products_path
  #   assert_equal 'Product was successfully deleted', flash[:notice]
  # end

  # test 'should report not authorized to delete a product' do
  #   sign_in @user = create(:user)

  #   product = create(:product)

  #   assert_no_difference('Product.count') do
  #     delete admin_product_url(product)
  #   end

  #   assert_redirected_to root_url
  #   assert_equal 'You are not authorized to perform this action.', flash[:alert]
  # end
  test 'should delete a product' do
    sign_in @user = create(:user, role: 'admin')

    product = create(:product)

    assert_difference('Product.count', -1) do
      delete admin_product_url(product)
    end

    assert_redirected_to products_path
    assert_equal 'Product was successfully deleted', flash[:notice]
  end

  test 'should report not authorized to delete a product' do
    sign_in @user = create(:user, role: 'support')

    product = create(:product)

    assert_no_difference('Product.count') do
      delete admin_product_url(product)
    end

    assert_redirected_to root_url
    assert_equal 'You are not authorized to perform this action.', flash[:alert]
  end

  test 'should add a tag to a product' do
    sign_in @user = create(:user, role: 'admin')

    product = create(:product)
    tag = create(:tag)

    post add_tag_admin_product_path(product), params: { tag_id: tag.id }

    assert_redirected_to product_path
    assert_equal 'Tag was successfully added', flash[:notice]
  end
end
