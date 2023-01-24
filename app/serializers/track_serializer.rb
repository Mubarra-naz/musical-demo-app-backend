class TrackSerializer
  include FastJsonapi::ObjectSerializer
  set_type :track
  attributes :id, :name, :price, :status, :created_at, :updated_at

  attribute :file do |obj|
    UrlHelpers.url_for(obj.wav_file)  if obj.wav_file.attached?
  end

  attribute :artists do |obj|
    obj.artist_tracks.map do |artist_track|
      UserSerializer.new(artist_track.artist)
    end
  end
end
