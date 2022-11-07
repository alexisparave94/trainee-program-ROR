# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sku { 'SKU-12345678' }
    name { 'Product 1' }
    description { 'This is a description' }
    price { 20.0 }
    stock { 10 }
  end
end
