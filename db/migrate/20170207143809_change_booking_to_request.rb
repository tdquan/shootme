class ChangeBookingToRequest < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :paid, :boolean
    add_reference :bookings, :client, references: :users
    add_column :bookings, :price, :float
    add_column :users, :price, :float

    create_table :requests do |t|
      t.references :user, foreign_key: true
      t.references :client, references: :users
      t.datetime :start_time
      t.datetime :end_time
      t.string :location
      t.float :price
      t.boolean :confirmed

      t.timestamps
    end
  end
end
