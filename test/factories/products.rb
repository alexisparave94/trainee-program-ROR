# frozen_string_literal: true

FactoryBot.define do
  factory :product do
    sku { 'SKU-12345678910' }
    name { 'Product 1' }
    description { 'This is a description' }
    price { 2000 }
    stock { 10 }
    likes_count { 1 }
    stripe_product_id { 'prod_MvTAJ3CHJT6BkK' }
  end
end
