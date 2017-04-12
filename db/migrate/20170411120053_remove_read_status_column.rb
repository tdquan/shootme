class RemoveReadStatusColumn < ActiveRecord::Migration[5.0]
  def change
    remove_column :messages, :read_status
  end
end
