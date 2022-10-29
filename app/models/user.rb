class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :validatable

  # Associations
  has_many :orders, dependent: :nullify
  has_many :change_logs, dependent: :nullify

  # Enum
  enum :role, %i[admin customer]
end
