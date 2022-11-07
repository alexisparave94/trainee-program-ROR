# frozen_string_literal: true

FactoryBot.define do
  factory :order do
    user
    status { 'pending' }
    total { 0.0 }
  end
end
