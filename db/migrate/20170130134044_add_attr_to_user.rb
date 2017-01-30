class AddAttrToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :photo, :string
    add_column :users, :description, :string
    add_column :users, :address, :string
    add_column :users, :postal_code, :integer
    add_column :users, :photographer, :boolean
  end
end
