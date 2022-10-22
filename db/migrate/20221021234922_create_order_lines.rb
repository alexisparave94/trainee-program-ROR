class CreateOrderLines < ActiveRecord::Migration[7.0]
  def change
    create_table :order_lines do |t|
      t.references :order, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :price
      t.decimal :total

      t.timestamps
    end

    add_index :order_lines, [:order_id, :product_id], unique: true
  end
end
