FactoryBot.define do
  factory :rate do
    value { "9.99" }
    user { nil }
    rateable { nil }
  end
end
