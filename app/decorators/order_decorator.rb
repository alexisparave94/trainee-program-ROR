# frozen_string_literal: true

# Class for decorators of orders
class OrderDecorator < BaseDecorator
  decorates :order

  def total_virtual_order(virtual_order)
    format('$ %0.02f', virtual_order.reduce(0) { |sum, line| sum + (line['quantity'].to_i * line['price'].to_f) } / 100)
  end
end
