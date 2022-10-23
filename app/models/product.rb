class Product < ApplicationRecord
  # Associations
  has_many :order_lines, dependent: :destroy
  has_many :orders, through: :order_lines

  # Scopes
  default_scope { order(:name) }
  scope :order_by_price, -> { order(:price) }
  scope :get_most_purchased_product, -> { joins(order_lines: :order).where('orders.status': 1).group(:id).order('SUM(order_lines.quantity) DESC').limit(1) }

  def self.get_products_which_name_has_words_greater_than_2_letters
    Product.all.select do |product|
      product.name.split(' ').any? { |word| word.length > 2 }
    end
  end

  # Validations
  validates :name, presence: { message: 'Must enter a name' }
  validates :name, uniqueness: { message: 'Name "%{value}" already exists' }
  validates :sku, presence: { message: 'Must enter a sku' }
  validates :sku, uniqueness: { message: 'Sku "%{value}" already exists' }
  validates :stock, numericality: { only_integer: true, message: 'Must be an integer' }
  validates :stock, numericality: { greater_than_or_equal_to: 0, message: 'Must be a positive number' }
  validates :price, numericality: { greater_than: 0, message: 'Must be a positive number greater than 0' }
end
