module Customer
  class OrderLineDeleter < ApplicationService
    def initialize(order_line)
      @order_line = order_line
      super()
    end

    def call
      delete_order
    end

    def delete_order
      @order_line.destroy
    end
  end
end
