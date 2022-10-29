class ChangeLog < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :description, presence: true 
end
