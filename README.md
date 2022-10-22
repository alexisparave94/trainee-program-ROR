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
