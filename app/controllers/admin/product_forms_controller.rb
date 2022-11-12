# frozen_string_literal: true

module Admin
  # Class to manage interactions between admin/support users and products
  class ProductFormsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_action
    before_action :set_user, only: %i[update]

    # Method to get the form to create a new product
    # - GET /admin/product_forms/new
    def new
      @product_form = Forms::ProductForm.new
    end

    # Method to create a new product
    # - POST /admin/product_forms
    def create
      @product_form = Forms::ProductForm.new(product_form_params, current_user)
      if @product_form.create
        redirect_to root_path, notice: 'Product was created successfully'
      else
        render :new, status: :unprocessable_entity
      end
    end

    # Method to get the form to edit a new product
    # - GET /admin/product_forms/:id/edit
    def edit
      @product_form = Forms::ProductForm.new(id: params[:id])
    end

    # Method to update a product
    # - PATCH /admin/product_forms/:id
    def update
      @product_form = Forms::ProductForm.new(product_form_params.merge(id: params[:id]))
      if @product_form.update
        redirect_to root_path, notice: 'Product was updated successfully'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    # Method to set strong paramas for product form
    def product_form_params
      params.require(:forms_product_form).permit(policy(Product).permitted_attributes)
    end

    # Method to authorize actions
    def authorize_action
      authorize Product
    end

    # Method to set current user
    def set_user
      User.define_user(current_user)
    end
  end
end
