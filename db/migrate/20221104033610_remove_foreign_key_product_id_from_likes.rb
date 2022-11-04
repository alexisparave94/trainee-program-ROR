class RemoveForeignKeyProductIdFromLikes < ActiveRecord::Migration[7.0]
  def change
    remove_reference :likes, :product, foreign_key: true
  end
end
