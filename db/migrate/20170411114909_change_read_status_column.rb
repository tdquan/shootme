class ChangeReadStatusColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :conversations, :read_status
    add_column :messages, :read_status, :boolean, default: false
  end
end
