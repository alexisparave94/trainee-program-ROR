# frozen_string_literal: true

# Service object to show a shopping cart
class OrdersSetter < ApplicationService
  def initialize(user, order_id, virtual_order)
    @user = user
    @order_id = order_id
    @virtual_order = virtual_order
    super()
  end

  def call
    set_orders
  end

  def set_orders
    @order = Order.find(@order_id) if @user
    [@order, @virtual_order]
  end
end
