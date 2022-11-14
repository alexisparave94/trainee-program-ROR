# frozen_string_literal: true

FactoryBot.define do
  factory :rate do
    value { '9.99' }
    user { nil }
    rateable { nil }
  end
end
