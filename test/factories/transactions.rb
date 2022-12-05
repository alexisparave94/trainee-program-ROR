FactoryBot.define do
  factory :transaction do
    user { nil }
    amount { 1 }
    status { "MyString" }
    description { "MyString" }
  end
end
