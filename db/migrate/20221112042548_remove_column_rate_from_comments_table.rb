class RemoveColumnRateFromCommentsTable < ActiveRecord::Migration[7.0]
  def change
    remove_column :comments, :rate, type: :decimal
  end
end
