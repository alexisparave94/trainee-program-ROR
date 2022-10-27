class AddForeignKeyCartIdToOrderLines < ActiveRecord::Migration[7.0]
  def change
    add_reference :order_lines, :cart, foreign_key: true, index: false, null: true
  end
end
