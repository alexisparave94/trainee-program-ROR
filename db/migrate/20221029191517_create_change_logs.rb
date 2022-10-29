class CreateChangeLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :change_logs do |t|
      t.string :description
      t.references :user, null: true, foreign_key: true

      t.timestamps
    end
  end
end
