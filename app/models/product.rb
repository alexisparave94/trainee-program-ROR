# frozen_string_literal: true

# Class to manage Product Model
class Product < ApplicationRecord
  before_update :save_change_log

  # Associations
  has_many :order_lines, dependent: :destroy
  has_many :orders, through: :order_lines
  has_many :likes, dependent: :destroy
  has_and_belongs_to_many :tags
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy

  # Scopes
  default_scope { order(:name) }
  scope :order_by_price, -> { order(:price) }
  scope :get_most_purchased_product, lambda {
                                       joins(order_lines: :order).where('orders.status': 1).group(:id)
                                                                 .order('SUM(order_lines.quantity) DESC').limit(1)
                                     }

  # Callback
  def save_change_log
    fields_and_values = changes.except('updated_at')
    fields_and_values.each do |key, value|
      ChangeLog.create(
        user: User.give_user,
        description: 'Update',
        product: name, field: key, previous_content: value[0], new_content: value[1]
      )
    end
  end

  def liked_by_current_user(current_user)
    likes.select { |like| like.user_id == current_user.id }.first
  end
end
