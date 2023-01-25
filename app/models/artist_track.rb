class ArtistTrack < ApplicationRecord
  self.table_name = "tracks_users"
  belongs_to :artist, class_name: 'User', foreign_key: 'user_id'
  belongs_to :track

  validates_uniqueness_of :user_id, scope: :track_id
end
