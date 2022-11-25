# frozen_string_literal: true

# Class to manage Product Model
class Product < ApplicationRecord
  include Discard::Model

  # Associations
  has_many :order_lines, dependent: :destroy
  has_many :orders, through: :order_lines
  has_many :likes, dependent: :destroy
  has_and_belongs_to_many :tags
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :rates, as: :rateable, dependent: :destroy
  has_one_attached :image

  # Scopes
  default_scope { order(:name) }
  scope :order_by_price, -> { order(:price) }
  scope :get_most_purchased_product, lambda {
                                       joins(order_lines: :order).where('orders.status': 1).group(:id)
                                                                 .order('SUM(order_lines.quantity) DESC').limit(1)
                                     }

  def liked_by_current_user(current_user)
    likes.select { |like| like.user_id == current_user.id }.first
  end

  def pending_comments_of_user(current_user)
    comments.includes(:user).pending.where(user_id: current_user.id)
  end

  def aproved_comments_of_produc
    comments.includes(:user).approved
  end

  has_one_attached :image do |attachable|
    attachable.variant :thumb, resize_to_limit: [220, 220]
  end
end
