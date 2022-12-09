# frozen_string_literal: true

module Admin
  # Class to manage interactions between admin/support users and products
  class ProductFormsController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_action
    after_action :set_id, only: %i[edit]
    after_action :reset_id, only: %i[update]

    # Method to get the form to create a new product
    # - GET /admin/product_forms/new
    def new
      run Operations::Admin::Products::Create::Present do |ctx|
        @product_form = ctx['contract.default']
      end
    end

    # Method to create a new product
    # - POST /admin/product_forms
    def create
      ctx = run Operations::Admin::Products::Create,
                params: { product: params[:product], current_user: } do
        return redirect_to root_path, notice: 'Product was successfully created'
      end
      @product_form = ctx['contract.default']
      flash[:error] = ctx['contract.default'].errors.messages
      render :new
    end

    # Method to get the form to edit a new product
    # - GET /admin/product_forms/:id/edit
    def edit
      run Operations::Admin::Products::Update::Present do |ctx|
        @product_form = ctx['contract.default']
      end
    end

    # Method to update a product
    # - PATCH /admin/product_forms/:id
    def update
      ctx = run Operations::Admin::Products::Update,
                params: { id: params[:id], product: params[:product], current_user: } do
        # flash[:notice] = 'Product was successfully updated'
        return redirect_to root_path, notice: 'Product was successfully updated'
      end

      @product_form = ctx['contract.default']
      flash[:error] = ctx['contract.default'].errors.messages
      render :edit
    end

    private

    # Method to set strong paramas for product form
    # def new_product_form_params
    #   params.require(:forms_new_product_form).permit(policy(Product).permitted_attributes)
    # end

    # def edit_product_form_params
    #   params.require(:forms_edit_product_form).permit(policy(Product).permitted_attributes)
    # end

    # Method to authorize actions
    def authorize_action
      authorize Product
    end

    def set_id
      session[:id] = params[:id]
    end

    def reset_id
      session[:id] = nil
    end
  end
end
