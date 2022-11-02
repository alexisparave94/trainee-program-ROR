class Order < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  has_many :order_lines, dependent: :destroy
  has_many :products, through: :order_lines

  # Callbacks
  # after_save :update_products_stock

  # Enum
  enum :status, %i[virtual pending completed refused]

   # Scopes
   scope :get_orders_beetween_dates_for_a_customer, ->(first_date, last_date, customer_id) { where("created_at BETWEEN ? AND ?", first_date, last_date).where("customer_id = ?", customer_id) }

  def add_lines_from_cart(virtual_order)
    virtual_order.each do |detail|
      order_line = OrderLine.create(
        product_id: detail['product']['id'],
        quantity: detail['order_line']['quantity'],
        price: detail['order_line']['price']
      )
      order_lines.push(order_line)
    end
  end

  def calculate_total
    order_lines.reduce(0) { |acc, order_line| acc + order_line.total }
  end

  def update_products_stock
    order_lines.each do |order_line|
      product = Product.find(order_line.product_id)
      product.stock -= order_line.quantity
      product.save
    end
  end

  def lines_exceed_stock
    order_lines.map do |line|
      stock = Product.find(line.product_id).stock
      current_quantity = line['quantity'].to_i
      stock < current_quantity ? { line:, stock: } : nil
    end
  end
end
