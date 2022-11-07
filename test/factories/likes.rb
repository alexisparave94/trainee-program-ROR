# frozen_string_literal: true

FactoryBot.define do
  factory :like do
    user
    for_product

    trait :for_product do
      association :likeable, factory: :product
    end
  end
end
