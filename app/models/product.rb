# frozen_string_literal: true

# Class to manage Product Model
class Product < ApplicationRecord
  # include Swagger::Blocks

  # swagger_schema :Product do
  #   key :required, [:id]
  #   property :data do
  #     property :id do
  #       key :type, :integer
  #       key :format, :int64
  #     end
  #     property :name do
  #       key :type, :string
  #     end
  #     property :description do
  #       key :type, :string
  #     end
  #     property :stock do
  #       key :type, :integer
  #       key :format, :int64
  #     end
  #     property :price do
  #       key :type, :string
  #     end
  #     property :likes_count do
  #       key :type, :integer
  #       key :format, :int64
  #     end
  #     property :image_url do
  #       key :type, :string
  #     end
  #     property :created_at do
  #       key :type, :string
  #     end
  #     property :updated_at do
  #       key :type, :string
  #     end
  #   end
  # end
  # before_update :save_change_log

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

  # Callback
  def save_change_log
    return if User.give_user&.customer?

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
