class CheckoutHandler < ApplicationService
  def initialize(virtual_order)
    @virtual_order = virtual_order
    super()
  end

  def call
    lines_exceed_stock.compact
  end

  private

  # Method to look for products that exceed the stock of an order
  def lines_exceed_stock
    @virtual_order.map do |line|
      stock = Product.find(line['id']).stock
      current_quantity = line['quantity'].to_i
      stock < current_quantity ? { line:, stock: } : nil
    end
  end
end
