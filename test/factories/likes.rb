FactoryBot.define do
  factory :like do
    user
    for_product

    trait :for_product do
      association :likeable, factory: :product
    end
  end
end
