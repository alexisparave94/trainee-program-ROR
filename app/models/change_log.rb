# frozen_string_literal: true

# Class to manage Change Log Model
class ChangeLog < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :description, presence: true

  def format_description(request_method)
    case request_method
    when 'POST'
      self.description = 'Create'
    when 'PATCH'
      self.description = 'Update'
    when 'DELETE'
      self.description = 'Delete'
    end
  end
end
