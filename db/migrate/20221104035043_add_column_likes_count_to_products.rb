class AddColumnLikesCountToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :likes_count, :integer, default: 0
  end
end
