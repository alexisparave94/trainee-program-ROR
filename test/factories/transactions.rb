# frozen_string_literal: true

FactoryBot.define do
  factory :transaction do
    user
    amount { 1000 }
    status { 'success' }
    description { 'Description' }
  end
end
