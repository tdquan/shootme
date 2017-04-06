class AddPhotosToAlbum < ActiveRecord::Migration[5.0]
  def change
    add_column :albums, :photos, :text
  end
end
