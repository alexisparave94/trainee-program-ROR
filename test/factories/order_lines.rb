FactoryBot.define do
  factory :order_line do
    order
    product
    quantity { 0 }
    price { 0.0 }
    total { 0.0 }
  end
end
