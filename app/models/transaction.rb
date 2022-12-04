class Transaction < ApplicationRecord
  belongs_to :user

  enum :status, %i[success failed]
end
