# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

puts 'Start Seeding'

puts 'Seeding Customers'
cus1 = Customer.create(first_name: 'Alexis', last_name: 'Parave')
cus2 = Customer.create(first_name: 'Mariano', last_name: 'Vargas')
cus3 = Customer.create(first_name: 'Fatima', last_name: 'Parave')
cus4 = Customer.create(first_name: 'Lazaro', last_name: 'Diaz')
cus5 = Customer.create(first_name: 'Daniel', last_name: 'Salazar')

puts 'Seeding Products'
pro1 = Product.create(sku: 'SKU-001', name: 'Product B', price: 10, stock: 5)
pro2 = Product.create(sku: 'SKU-002', name: 'Product A', price: 20, stock: 5)
pro3 = Product.create(sku: 'SKU-003', name: 'Product C', price: 50, stock: 5)
pro4 = Product.create(sku: 'SKU-004', name: 'AB', price: 100, stock: 5)
pro5 = Product.create(sku: 'SKU-005', name: 'AA', price: 200, stock: 5)

puts 'Seeding Orders'
or1 = Order.create(customer: cus1, status: 1)
or2 = Order.create(customer: cus2, status: 1)
or3 = Order.create(customer: cus3, status: 1)
or4 = Order.create(customer: cus4, status: 1)
or5 = Order.create(customer: cus1, status: 1)
or6 = Order.create(customer: cus2, status: 0)
or7 = Order.create(customer: cus3, status: 1)
or8 = Order.create(customer: cus1, status: 1)

puts 'Seeding Order Lines'
orl1 = OrderLine.create(order: or1, product: pro1, quantity: 2)
orl2 = OrderLine.create(order: or1, product: pro2, quantity: 2)
orl3 = OrderLine.create(order: or1, product: pro3, quantity: 2)
orl4 = OrderLine.create(order: or1, product: pro4, quantity: 2)
orl5 = OrderLine.create(order: or1, product: pro5, quantity: 2)
orl6 = OrderLine.create(order: or2, product: pro1, quantity: 4)
orl7 = OrderLine.create(order: or2, product: pro2, quantity: 4)
orl8 = OrderLine.create(order: or3, product: pro3, quantity: 1)
orl9 = OrderLine.create(order: or3, product: pro4, quantity: 1)
orl10 = OrderLine.create(order: or4, product: pro1, quantity: 3)
orl11 = OrderLine.create(order: or4, product: pro2, quantity: 3)
orl12 = OrderLine.create(order: or5, product: pro5, quantity: 1)
orl13 = OrderLine.create(order: or6, product: pro1, quantity: 2)
orl14 = OrderLine.create(order: or7, product: pro1, quantity: 2)
orl15 = OrderLine.create(order: or7, product: pro2, quantity: 2)
orl16 = OrderLine.create(order: or7, product: pro3, quantity: 2)
orl17 = OrderLine.create(order: or8, product: pro1, quantity: 2)
orl18 = OrderLine.create(order: or8, product: pro2, quantity: 2)

puts 'Finish Seeding'