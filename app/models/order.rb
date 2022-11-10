# frozen_string_literal: true

# Class to manage Product Model
class Order < ApplicationRecord
  # Associations
  belongs_to :user, optional: true
  has_many :order_lines, dependent: :destroy
  has_many :products, through: :order_lines
  has_many :comments, as: :commentable, dependent: :destroy

  # Enum
  enum :status, %i[pending completed refused]

  # Scopes
  scope :get_orders_beetween_dates_for_a_customer, lambda { |first_date, last_date, customer_id|
                                                     where('created_at BETWEEN ? AND ?', first_date, last_date)
                                                       .where('customer_id = ?', customer_id)
                                                   }

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
end
