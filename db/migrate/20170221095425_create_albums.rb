class CreateAlbums < ActiveRecord::Migration[5.0]
  def change
    create_table :albums do |t|
      t.string :name
      t.string :tags
      t.text :description

      t.references :user, foreign_key: true
    end
  end
end
