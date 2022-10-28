# require 'faker'

# puts 'Start Seeding'

# puts 'Seedding Customers'
# 5.times do
#   customer = Customer.new
#   customer.first_name = Faker::Name.unique.first_name
#   customer.last_name = Faker::Name.unique.last_name
#   customer.address = Faker::Address.street_address
#   customer.phone = Faker::PhoneNumber.cell_phone_in_e164
#   p customer.save
# end

# puts 'Seedding Products'
# 20.times do
#   product = Product.new
#   product.sku = Faker::Number.unique.number(digits: 10)
#   product.name = Faker::Commerce.unique.product_name
#   product.description = Faker::Lorem.paragraph(sentence_count: 2, supplemental: true, random_sentences_to_add: 10)
#   product.price = Faker::Number.within(range: 10..100)
#   product.stock = Faker::Number.within(range: 1..25)
#   product.save
# end

# puts 'Seedding Orders'
# 10.times do
#   order = Order.new
#   order.customer = Customer.all.sample
#   order.status = Faker::Number.within(range: 0..2)
#   order.save
# end

# puts 'Seedding Order Lines'
# 20.times do
#   order_line = OrderLine.new
#   order_line.order = Order.all.sample
#   order_line.product = Product.all.sample
#   order_line.quantity = Faker::Number.within(range: 1..5)
#   order_line.save
# end

# puts 'Finish Seeding'

puts 'Start Seeding'

# puts 'Seeding Customers'
# user1 = User.create(first_name: 'Alexis', last_name: 'Parave')
# user2 = User.create(first_name: 'Mariano', last_name: 'Vargas')
# user3 = User.create(first_name: 'Fatima', last_name: 'Parave')
# user4 = User.create(first_name: 'Lazaro', last_name: 'Diaz')
# user5 = User.create(first_name: 'Daniel', last_name: 'Salazar')

puts 'Seeding Products'
pro1 = Product.create(sku: 'SKU-001', name: 'Product B', price: 10, stock: 5)
pro2 = Product.create(sku: 'SKU-002', name: 'Product A', price: 20, stock: 5)
pro3 = Product.create(sku: 'SKU-003', name: 'Product C', price: 50, stock: 5)
pro4 = Product.create(sku: 'SKU-004', name: 'AB', price: 100, stock: 5)
pro5 = Product.create(sku: 'SKU-005', name: 'AA', price: 200, stock: 5)

# puts 'Seeding Orders'
# or1 = Order.create(customer: cus1, status: 1)
# or2 = Order.create(customer: cus2, status: 1)
# or3 = Order.create(customer: cus3, status: 1)
# or4 = Order.create(customer: cus4, status: 1)
# or5 = Order.create(customer: cus1, status: 1)
# or6 = Order.create(customer: cus2, status: 0)
# or7 = Order.create(customer: cus3, status: 1)
# or8 = Order.create(customer: cus1, status: 1)

# puts 'Seeding Order Lines'
# orl1 = OrderLine.create(order: or1, product: pro1, quantity: 2)
# orl2 = OrderLine.create(order: or1, product: pro2, quantity: 2)
# orl3 = OrderLine.create(order: or1, product: pro3, quantity: 2)
# orl4 = OrderLine.create(order: or1, product: pro4, quantity: 2)
# orl5 = OrderLine.create(order: or1, product: pro5, quantity: 2)
# orl6 = OrderLine.create(order: or2, product: pro1, quantity: 4)
# orl7 = OrderLine.create(order: or2, product: pro2, quantity: 4)
# orl8 = OrderLine.create(order: or3, product: pro3, quantity: 1)
# orl9 = OrderLine.create(order: or3, product: pro4, quantity: 1)
# orl10 = OrderLine.create(order: or4, product: pro1, quantity: 3)
# orl11 = OrderLine.create(order: or4, product: pro2, quantity: 3)
# orl12 = OrderLine.create(order: or5, product: pro5, quantity: 1)
# orl13 = OrderLine.create(order: or6, product: pro1, quantity: 2)
# orl14 = OrderLine.create(order: or7, product: pro1, quantity: 2)
# orl15 = OrderLine.create(order: or7, product: pro2, quantity: 2)
# orl16 = OrderLine.create(order: or7, product: pro3, quantity: 2)
# orl17 = OrderLine.create(order: or8, product: pro1, quantity: 2)
# orl18 = OrderLine.create(order: or8, product: pro2, quantity: 2)

puts 'Finish Seeding'
