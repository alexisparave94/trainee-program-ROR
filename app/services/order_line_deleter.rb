# frozen_string_literal: true

# Service object to delete a product of a shopping cart
# for a no logged in user
class OrderLineDeleter < ApplicationService
  def initialize(id_order_line, virtual_order)
    @id_order_line = id_order_line
    @virtual_order = virtual_order
    super()
  end

  def call
    delete_virtual_order_line
  end

  private

  def delete_virtual_order_line
    @virtual_order.reject { |line| line['id'] == @id_order_line.to_i }
  end
end
