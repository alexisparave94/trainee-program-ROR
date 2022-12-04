class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :amount
      t.integer :status
      t.string :description

      t.timestamps
    end
  end
end
