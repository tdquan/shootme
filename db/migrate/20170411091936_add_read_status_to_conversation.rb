class AddReadStatusToConversation < ActiveRecord::Migration[5.0]
  def change
    add_column :conversations, :read_status, :boolean, null: false, default: true
  end
end
