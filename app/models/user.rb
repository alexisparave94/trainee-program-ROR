# frozen_string_literal: true

# Class to manage User Model
class User < ApplicationRecord
  attr_accessor :user

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :validatable

  # Associations
  has_many :orders, dependent: :nullify
  has_many :change_logs, dependent: :nullify
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :rates, dependent: :destroy

  # Callback
  before_validation :uniq_admin

  # Validations
  # validates :role, uniqueness: { message: "You can't create more than one admin user" }, if: :user_admin?

  # validate :uniq_admin

  def uniq_admin
    return if User.admin.empty?

    errors.add(:role, "You can't create more than one admin user")
  end

  # Enum
  enum :role, %i[admin customer support]

  def self.define_user(user)
    @current_user = user
  end

  def self.give_user
    @current_user
  end
end
