class CreateRates < ActiveRecord::Migration[7.0]
  def change
    create_table :rates do |t|
      t.decimal :value
      t.references :user, null: false, foreign_key: true
      t.references :rateable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
