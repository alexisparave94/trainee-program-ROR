# frozen_string_literal: true

# Service object to empty a shopping cart
# for a no logged in user
class ShoppingCartEmptier < ApplicationService
  def call
    empty_cart
  end

  def empty_cart
    nil
  end
end
