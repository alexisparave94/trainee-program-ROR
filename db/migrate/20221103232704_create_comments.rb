class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      t.references :user, null: false, foreign_key: true
      t.text :description
      t.decimal :rate
      t.references :commentable, polymorphic: true, null: false

      t.timestamps
    end
  end
end
