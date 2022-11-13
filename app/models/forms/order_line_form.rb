# frozen_string_literal: true

module Forms
  # Class to manage Order line Form model
  class OrderLineForm
    include ActiveModel::Model

    attr_accessor :product_id, :price, :quantity, :order_id, :total, :product

    # Validations
    validates :quantity, numericality: { only_integer: true, message: 'Quantity must be an integer' }
    validates :quantity,
              numericality: { greater_than_or_equal_to: 1, 
                              message: 'Quantity must be a positive number greather than 0' }

    def initialize(attr = {})
      @product = attr[:product_id] && Product.find(attr[:product_id])
      if attr[:id].nil?
        super(attr)
      else
        @order_line = OrderLine.find(attr[:id])
        self.product_id = attr[:product_id].nil? ? @order_line.product_id : attr[:product_id]
        self.price =  attr[:price].nil? ? @order_line.price : attr[:price]
        self.quantity = attr[:quantity].nil? ? @order_line.quantity : attr[:quantity]
        self.order_id = attr[:order_id].nil? ? @order_line.order_id : attr[:order_id]
        self.total = attr[:total].nil? ? @order_line.total : attr[:total]
      end
    end

    def update
      return false unless valid?

      @order_line.update(quantity:)
    end

    def id
      @order_line.nil? ? nil : @order_line.id
    end
  end
end
