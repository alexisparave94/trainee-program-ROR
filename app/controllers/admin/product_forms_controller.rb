# frozen_string_literal: true

module Admin
  # Class to manage interactions between admin/support users and products
  class ProductFormsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_action
    before_action :set_user, only: %i[update]
    after_action :set_id, only: %i[edit]
    after_action :reset_id, only: %i[update]

    # Method to get the form to create a new product
    # - GET /admin/product_forms/new
    def new
      @product_form = Admins::NewProductFormGetter.call
    end

    # Method to create a new product
    # - POST /admin/product_forms
    def create
      @product_form = Admins::ProductCreator.call(new_product_form_params, current_user)
      redirect_to root_path, notice: 'Product was successfully created'
    rescue StandardError => e
      flash[:error] = e
      redirect_to new_admin_product_form_path
    end

    # Method to get the form to edit a new product
    # - GET /admin/product_forms/:id/edit
    def edit
      @product_form = Admins::EditProductFormGetter.call(id: params[:id])
    end

    # Method to update a product
    # - PATCH /admin/product_forms/:id
    def update
      Admins::ProductUpdater.call(edit_product_form_params, params[:id], current_user)
      redirect_to root_path, notice: 'Product was successfully updated'
    rescue StandardError => e
      flash[:error] = e
      redirect_to edit_admin_product_form_path(id: session[:id])
    end

    private

    # Method to set strong paramas for product form
    def new_product_form_params
      params.require(:forms_new_product_form).permit(policy(Product).permitted_attributes)
    end

    def edit_product_form_params
      params.require(:forms_edit_product_form).permit(policy(Product).permitted_attributes)
    end

    # Method to authorize actions
    def authorize_action
      authorize Product
    end

    # Method to set current user
    def set_user
      User.define_user(current_user)
    end

    def set_id
      session[:id] = params[:id]
    end

    def reset_id
      session[:id] = nil
    end
  end
end
