class AddLonglatitudeToRequestAndBooking < ActiveRecord::Migration[5.0]
  def change
    add_column :requests, :longitude, :float
    add_column :requests, :latitude, :float
    add_column :bookings, :longitude, :float
    add_column :bookings, :latitude, :float
  end
end
