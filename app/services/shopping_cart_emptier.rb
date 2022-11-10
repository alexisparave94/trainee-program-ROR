class ShoppingCartEmptier < ApplicationService
  def call
    empty_cart
  end

  def empty_cart
    nil
  end
end
