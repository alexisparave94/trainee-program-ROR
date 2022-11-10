class OrderLineDeleter < ApplicationService
  def initialize(id_order_line, virtual_order)
    super
    @id_order_line = id_order_line
    @virtual_order = virtual_order
  end

  def call
    delete_virtual_order_line
  end

  private

  def delete_virtual_order_line
    @virtual_order.reject { |line| line['id'] == @id_order_line.to_i }
  end
end