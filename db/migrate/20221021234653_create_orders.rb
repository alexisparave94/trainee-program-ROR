class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.references :customer, null: true, foreign_key: true
      t.decimal :total, default: 0
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
