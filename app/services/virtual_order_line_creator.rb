# frozen_string_literal: true

# Service object to create a virtual order line
class VirtualOrderLineCreator < ApplicationService
  class NotValidEntryRecord < StandardError; end

  def initialize(params, virtual_order)
    @params = params
    @virtual_order = virtual_order
    @product = @params[:product_id] && Product.find(@params[:product_id])
    super()
  end

  def call
    @order_line_form = Forms::OrderLineForm.new(@params)
    raise(NotValidEntryRecord, parse_errors) unless @order_line_form.valid?

    add_virtual_product
  end

  private

  def parse_errors
    @order_line_form.errors.messages.map { |_key, error| error }.join(', ')
  end

  # Method to add a new line or if the line exists only sum quantities
  def add_virtual_product
    look_for_virtual_line_in_virtual_order
    if @virtual_line
      @virtual_line['quantity'] += @params[:quantity].to_i
    else
      @virtual_order << { id: @product.id, name: @product.name, price: @product.price.to_f,
                          quantity: @params[:quantity].to_i }
    end
  end

  # Method to look for a product in a virtual order
  def look_for_virtual_line_in_virtual_order
    @virtual_line = @virtual_order.select { |line| line['id'] == @product.id }.first
  end
end
