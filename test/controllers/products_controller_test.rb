# frozen_string_literal: true

require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index products' do
    get products_url
    assert_response :success
  end

  test 'should show a product' do
    product = create(:product)
    get product_url(product)
    assert_response :success
  end

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

  # API

  test 'should get index products api' do
    get api_v1_products_url
    assert_response :success
  end

  test 'should get index products for an admin user api' do
    @user = create(:user,role: 'admin')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    get api_v1_admin_products_url, headers: { Authorization: token }
    assert_response :success
  end

  test 'should get index products api with pagination' do
    get api_v1_products_url, params: { page: 1, limit: 10 }
    pagination = response.parsed_body['meta']['pagination']
    assert_response :success
    assert_equal pagination['page'], 1
    assert_equal pagination['limit'], 10
  end

  test 'should show a product api' do
    product = create(:product)
    get api_v1_product_url(product)
    assert_response :success
  end

  test 'should show a product for an admin user api' do
    @user = create(:user,role: 'admin')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    product = create(:product)
    get api_v1_admin_product_url(product), headers: { Authorization: token }
    assert_response :success
  end

  test 'should report not found product api' do
    get api_v1_product_url(id: 'xxx')
    assert_response :not_found
  end

  test 'should create a product api' do
    @user = create(:user, role: 'admin')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    product = build(:product)
    assert_difference('Product.count') do
      post api_v1_admin_products_url, params: { forms_new_product_form: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: product.stock } }, headers: { Authorization: token }
    end

    assert_response :success
  end

  test 'should respond unathorized to a create product api' do
    product = build(:product)
    assert_no_difference('Product.count') do
      post api_v1_admin_products_url, params: { forms_new_product_form: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: product.stock } }
    end

    assert_response :unauthorized
  end

  test 'should respond unprocessable entity to create a product api' do
    @user = create(:user, role: 'admin')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    product = build(:product)
    assert_no_difference('Product.count') do
      post api_v1_admin_products_url, params: { forms_new_product_form: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: -10 } }, headers: { Authorization: token }
    end

    assert_response :unprocessable_entity
  end

  test 'should update a product api' do
    @user = create(:user, role: 'admin')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    product = create(:product)
    patch api_v1_admin_product_url(product), params: { forms_edit_product_form: { sku: product.sku, name: product.name, description: product.description, price: 10, stock: 20 } }, headers: { Authorization: token }

    product = response.parsed_body['data']['product']

    assert_response :success
    assert_equal product['price'], 10
    assert_equal product['stock'], 20
  end

  test 'should respond unathorized to update a product api' do
    product = create(:product)

    patch api_v1_admin_product_url(product), params: { forms_edit_product_form: { sku: product.sku, name: product.name, description: product.description, price: 10, stock: 20 } }

    assert_response :unauthorized
  end

  test 'should respond unprocessable entity to update a product api' do
    @user = create(:user, role: 'admin')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    product = create(:product)

    patch api_v1_admin_product_url(product), params: { forms_edit_product_form: { sku: product.sku, name: product.name, description: product.description, price: product.price, stock: -10 } }, headers: { Authorization: token }

    assert_response :unprocessable_entity
  end

  test 'should delete a product api' do
    @user = create(:user, role: 'admin')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    product = create(:product)
    assert_difference('Product.count', -1) do
      delete api_v1_admin_product_url(product), headers: { Authorization: token }
    end

    assert_response :no_content
  end

  test 'should repsond not found delete a product api' do
    @user = create(:user, role: 'admin')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    assert_no_difference('Product.count') do
      delete api_v1_admin_product_url(id: 'xxx'), headers: { Authorization: token }
    end

    assert_response :not_found
  end

  test 'should soft delete a product api' do
    @user = create(:user, role: 'admin')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    product = create(:product)

    patch discard_api_v1_admin_product_url(product), headers: { Authorization: token }

    assert_response :success
  end

  test 'should restore a product api' do
    @user = create(:user, role: 'admin')
    post api_v1_sign_in_url, params: { email: @user.email, password: @user.password }

    token = response.parsed_body['data']['session']['token']

    product = create(:product)

    patch discard_api_v1_admin_product_url(product), headers: { Authorization: token }

    product.reload

    patch restore_api_v1_admin_product_url(product), headers: { Authorization: token }

    assert_response :success
  end
end
