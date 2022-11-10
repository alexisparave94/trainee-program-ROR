class OrderLineForm
  include ActiveModel::Model

  attr_accessor(
    :product_id,
    :price,
    :quantity,
    :order_id,
    :total
  )

  # Validations
  validates :quantity, numericality: { only_integer: true, message: 'Quantity must be an integer' }
  validates :quantity,
            numericality: { greater_than_or_equal_to: 1, message: 'Quantity must be a positive number greather than 0' }

  def initialize(attr = {})
    @product = attr[:product_id] && Product.find(attr[:product_id])
    if attr[:id].nil?
      super(attr)
    else
      @order_line = OrderLine.find(attr[:id])
      self.product_id = attr[:product_id].nil? ? @product.product_id : attr[:product_id]
      self.price =  attr[:price].nil? ? @product.price : attr[:price]
      self.quantity = attr[:quantity].nil? ? @product.quantity : attr[:quantity]
      self.order_id = attr[:order_id].nil? ? @product.order_id : attr[:order_id]
      self.total = attr[:total].nil? ? @product.total : attr[:total]
    end
  end

  # def persisted?
  #   !@product.nil?
  # end

  # def id
  #   @product.nil? ? nil : @product.id
  # end

  def create(virtual_order, quantity)
    return false unless valid?

    add_product(virtual_order, quantity)
  end

  def update(virtual_order)
    return false unless valid?

    puts '======================='
    set_virtual_line(virtual_order)
    set_quantity_for_virtual_line
    virtual_order
  end

  private

  # Method to add a new line or if the line exists only sum quantities
  def add_product(virtual_order, quantity)
    look_for_virtual_line_in_virtual_order(virtual_order)
    if @virtual_line
      @virtual_line['quantity'] += quantity.to_i
    else
      virtual_order << { id: @product.id, name: @product.name, price: @product.price.to_f,
                          quantity: quantity.to_i }
    end
    virtual_order
  end

  # Method to look for a product in a virtual order
  def look_for_virtual_line_in_virtual_order(virtual_order)
    @virtual_line = virtual_order.select { |line| line['id'] == @product.id }.first
  end

  # Method to set a virtual line
  def set_virtual_line(virtual_order)
    pp @virtual_line = virtual_order.select { |line| @product.id.to_i == line['id'] }.first
  end

  # Method to set the quantity of a virtual line
  def set_quantity_for_virtual_line
    @virtual_line['quantity'] = self.quantity.to_i
  end
end