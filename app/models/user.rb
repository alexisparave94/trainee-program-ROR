# frozen_string_literal: true

# Class to manage User Model
class User < ApplicationRecord
  include Discard::Model
  after_create :create_stripe_customer

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :validatable, :recoverable

  # Associations
  has_many :orders, dependent: :nullify
  has_many :change_logs, dependent: :nullify
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :received_comments, class_name: 'Comment', as: :commentable, dependent: :destroy

  # Callback
  # before_validation :uniq_admin

  # Validations
  # validates :role, uniqueness: { message: "You can't create more than one admin user" }, if: :user_admin?

  # validate :uniq_admin

  # def uniq_admin
  #   return if !admin? || User.admin.empty?

  #   errors.add(:role, "You can't create more than one admin user")
  # end

  # Enum
  enum :role, %i[admin customer support]

  def active_for_authentication?
    super && !discarded?
  end

  def create_stripe_customer
    customer = Stripe::Customer.create(email:)
    update(stripe_customer_id: customer.id)
  end
end
