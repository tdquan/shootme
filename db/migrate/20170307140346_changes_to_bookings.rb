class ChangesToBookings < ActiveRecord::Migration[5.0]
  def change
    remove_column :bookings, :user_id
    remove_column :bookings, :client_id
    add_reference :bookings, :request, foreign_key: true
  end
end
