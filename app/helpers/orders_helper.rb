# frozen_string_literal: true

module OrdersHelper
  def self.total_virtual_order(virtual_order)
    virtual_order.reduce(0) do |acc, detail|
      acc + (detail['order_line']['quantity'] * detail['order_line']['price'].to_f)
    end
  end
end
