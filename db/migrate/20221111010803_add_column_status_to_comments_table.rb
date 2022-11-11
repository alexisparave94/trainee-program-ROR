class AddColumnStatusToCommentsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :comments, :status, :integer, default: 0
  end
end
