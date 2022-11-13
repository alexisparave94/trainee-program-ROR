# frozen_string_literal: true

# Service object to create a virtual order line
class VirtualOrderLineUpdater < ApplicationService
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

    define_virtual_line
    set_quantity_for_virtual_line
  end

  private

  def parse_errors
    @order_line_form.errors.messages.map { |_key, error| error }.join(', ')
  end

  # Method to set a virtual line
  def define_virtual_line
    @virtual_line = @virtual_order.select { |line| @product.id.to_i == line['id'].to_i }.first
  end

  # Method to set the quantity of a virtual line
  def set_quantity_for_virtual_line
    @virtual_line['quantity'] = @params[:quantity].to_i
  end
end
