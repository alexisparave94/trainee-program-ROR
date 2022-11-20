# frozen_string_literal: true

# Module for Shopping Cart Helpers
module ShoppingCartHelper
  def show_empty_messsage?(virtual_order, current_user, order)
    (virtual_order.nil? && current_user.nil?) || (current_user && order.order_lines.empty?)
  end
end
