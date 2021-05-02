class CreateArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :artists do |t|
      t.string :artist_id
      t.string :name
      t.integer :age
      t.string :albums
      t.string :tracks
      t.string :self

      t.timestamps
    end
  end
end
