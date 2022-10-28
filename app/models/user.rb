class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  # Associations
  has_many :orders, dependent: :nullify

  # Validations
  validates :first_name, length: { minimum: 2, message: 'Must enter a valid first or last name', if: -> { last_name.nil? } }
  validates :last_name, length: { minimum: 2, message: 'Must enter a valid first or last name', if: -> { first_name.nil? } }
end
