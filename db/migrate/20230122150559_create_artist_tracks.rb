class CreateArtistTracks < ActiveRecord::Migration[6.1]
  def change
    create_table :artist_tracks do |t|
      t.belongs_to :user
      t.belongs_to :track

      t.timestamps
    end
  end
end
