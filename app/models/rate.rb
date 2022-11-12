# frozen_string_literal: true

class Rate < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :rateable, polymorphic: true
end
