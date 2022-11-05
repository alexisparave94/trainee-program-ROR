class AddColumnsToChangeLogsTable < ActiveRecord::Migration[7.0]
  def change
    add_column :change_logs, :field, :string, default: '-'
    add_column :change_logs, :previous_content, :string, default: '-'
    add_column :change_logs, :new_content, :string, default: '-'
  end
end
