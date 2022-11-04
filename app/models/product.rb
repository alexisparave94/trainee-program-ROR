# frozen_string_literal: true

class Product < ApplicationRecord
  # Associations
  has_many :order_lines, dependent: :destroy
  has_many :orders, through: :order_lines
  has_many :likes, dependent: :destroy
  has_and_belongs_to_many :tags
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  # Scopes
  default_scope { order(:name) }
  scope :available_products, -> { where('stock > 0') }
  scope :order_by_price, -> { order(:price) }
  scope :get_most_purchased_product, lambda {
                                       joins(order_lines: :order).where('orders.status': 1).group(:id).order('SUM(order_lines.quantity) DESC').limit(1)
                                     }

  def self.get_products_which_name_has_words_greater_than_2_letters
    Product.all.select do |product|
      product.name.split.any? { |word| word.length > 2 }
    end
  end

  scope :filter_by_tag, ->(tags) { joins(:tags).where(tags: { id: tags }) }
  scope :order_by_likes, -> { unscoped.order(likes_count: :DESC) }
  scope :order_by_name, ->(form) { unscoped.order(name: form) }

  # Validations
  validates :name, presence: { message: 'Must enter a name' }
  validates :name, uniqueness: { message: 'Name "%<value>s" already exists' }
  validates :sku, presence: { message: 'Must enter a sku' }
  validates :sku, uniqueness: { message: 'Sku "%<value>s" already exists' }
  validates :stock, numericality: { only_integer: true, message: 'Must be an integer' }
  validates :stock, numericality: { greater_than_or_equal_to: 0, message: 'Must be a positive number' }
  validates :price, numericality: { greater_than: 0, message: 'Must be a positive number greater than 0' }
end
