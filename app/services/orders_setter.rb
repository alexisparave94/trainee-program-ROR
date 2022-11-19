# frozen_string_literal: true

# Service object to set orders
class OrdersSetter < ApplicationService
  def initialize(user, order_id, virtual_order)
    @user = user
    @order_id = order_id
    @virtual_order = virtual_order
    super()
  end

  def call
    set_order
    raise(StandardError, 'The purchase has been completed') unless @order.pending?

    [@order, @virtual_order]
  end

  def set_order
    @order = Order.find(@order_id) if @user
  end
end
