# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :validatable

  # Associations
  has_many :orders, dependent: :nullify
  has_many :change_logs, dependent: :nullify
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  # Enum
  enum :role, %i[admin customer]

  def get_last_rate(product)
    comments.where(commentable_id: product.id).order(created_at: :DESC).first&.rate
  end
end
