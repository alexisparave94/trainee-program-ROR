class Cart < ApplicationRecord
  # Associations
  has_many :order_lines, dependent: :destroy

  def add_product(order_line_params)
    current_line = order_lines.find_by(product_id: order_line_params[:product_id])
    if current_line
      current_line.quantity += order_line_params[:quantity].to_i
    else
      current_line = order_lines.create(order_line_params)
    end
    current_line
  end

  def calculate_total
    order_lines.reduce(0) { |acc, order_line| acc + order_line.total }
  end
end
