class AddRolesToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :photographer
    add_column :users, :role, :string
    add_column :users, :pro, :boolean
  end
end
