class Order < ApplicationRecord
  # Associations
  belongs_to :customer, optional: true
  has_many :order_lines, dependent: :destroy
  has_many :products, through: :order_lines

  # Enum
  enum :status, %i[pending completed refused]

   # Scopes
   scope :get_orders_beetween_dates_for_a_customer, ->(first_date, last_date, customer_id) { where("created_at BETWEEN ? AND ?", first_date, last_date).where("customer_id = ?", customer_id) }

  def add_lines_from_cart(cart)
    cart.order_lines.each do |order_line|
      order_line.cart_id = nil
      order_lines.push(order_line)
    end
  end
end
