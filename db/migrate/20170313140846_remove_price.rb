class RemovePrice < ActiveRecord::Migration[5.0]
  def change
    remove_column :bookings, :price
    remove_column :requests, :price
  end
end
