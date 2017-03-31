class AddFeeToUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :price
    add_monetize :users, :fee, currency: { present: false }
  end
end
