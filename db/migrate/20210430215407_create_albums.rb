class CreateAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :albums do |t|
      t.string :name
      t.string :genre
      t.string :artist
      t.string :tracks
      t.string :self

      t.timestamps
    end
  end
end
