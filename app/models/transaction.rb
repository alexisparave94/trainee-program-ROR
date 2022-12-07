# frozen_string_literal: true

class Transaction < ApplicationRecord
  belongs_to :user

  enum :status, %i[success failed]
end
