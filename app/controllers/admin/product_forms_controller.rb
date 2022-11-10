class Admin::ProductFormsController < ApplicationController
  def new
    @product_form = ProductForm.new
  end

  def create
    @product_form = ProductForm.new(product_form_params)
    if @product_form.create
      redirect_to root_path, notice: 'Product was created successfully'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @product_form = ProductForm.new(id: params[:id])
  end

  def update
    @product_form = ProductForm.new(product_form_params.merge(id: params[:id]))
    if @product_form.update
      redirect_to root_path, notice: 'Product was updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def product_form_params
    params.require(:product_form).permit(:name, :sku, :description, :stock, :price)
  end
end