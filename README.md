# Inventory App

## Schema

- Create customer Table
```console
rails g model Customer first_name last_name address phone
```

- Create product Table
```console
rails g model Product sku:uniq name:uniq description price:decimal stock:integer
```
- Create order Table
```console
rails g model Order customer:references total:decimal status:integer
```

- Create order_lines Table
```console
rails g model OrderLine order:references product:references quantity:integer price:decimal total:decimal
```

## Queries using Active Record

- Get a random Product
```console
Product.all.sample
```

- Select the order of a specific order line
```console
OrderLine.find(X).order
```

- Select all orders that contains an X product
```console
Product.find(X).orders
```

- Select the total of sales of X product
```console
OrderLine.joins(:product, :order).where('orders.status': 1).where('products.id': X).sum('order_lines.total')
```

- Select all the costumers who bought a product with price greater than $60, sorted by product name (include customer, product and order information)
```console
Customer.includes(orders: { order_lines: :product }).where('orders.status': 1).where(orders: { order_lines: { price: 60... } }).order('products.name': :ASC)
```
```console
Customer.includes(orders: { order_lines: :product }).where('orders.status': 1).where('order_lines.price': 60... ).order('products.name')
```

- Select all orders between dates X and Y
```console
Order.where(created_at: '19-10-2022'..'23-10-2022')
```

- Count the total of customers who buy a product, with the amount of product ordered desc by total customer
```console
Customer.joins(orders: :order_lines).where('orders.status': 1).group('product_id').distinct.order('COUNT(customers.id) DESC').sum('quantity')
```

- Select all the products a X customer has bought ordered by date
```console
Product.joins(order_lines: :order).where('orders.status': 1).where('orders.customer_id': 1).order('orders.updated_at': :DESC)
```

- Select the total amount of products a X costumer bought between 2 dates
```console
OrderLine.joins(order: :customer).where('orders.status': 1).where('customers.id': X).where('orders.updated_at': '18-10-2022'..'23-10-2022').sum('order_lines.quantity')
```

- Select the id of 3 customers that has expend more
```console
Customer.select('id').joins(:orders).where('orders.status': 1).group('id').order('SUM(orders.total) DESC').limit(3)
```
```console
Customer.joins(:orders).where('orders.status': 1).group('id').order('SUM(orders.total) DESC').limit(3).map{ |customer| customer.id }
```

- Select what is the most purchased product
```console
Product.joins(order_lines: :order).where('orders.status': 1).group('id').order('SUM(order_lines.quantity) DESC').limit(1)
```

- Update products stock to 10 with stock smaller than 3 
```console
Product.where(stock: ...3).update_all(stock: 10)
```
