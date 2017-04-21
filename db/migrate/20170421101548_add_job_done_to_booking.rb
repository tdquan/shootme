class AddJobDoneToBooking < ActiveRecord::Migration[5.0]
  def change
    add_column :bookings, :client_confirmed, :boolean, default: false
    add_column :bookings, :user_confirmed, :boolean, default: false

    create_table :job_codes do |t|
      t.references :booking, foreign_key: true
      t.string :code
      t.boolean :used, default: false
      t.datetime :code_expiry

      t.timestamps
    end
  end
end
