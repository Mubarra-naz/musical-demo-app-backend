class Api::TracksController < ApiController
  before_action :logged_in?, only: [:download]

  def index
    @tracks = Track.published
    @favourite_tracks = current_user.favourite_tracks if logged_in?
    render json: TrackSerializer.new(@tracks, params: { favourite_tracks: @favourite_tracks })
  end

  def download
    track = Track.find(params[:id])
    track.save_opus_file
    if track.opus_file.attached?
      render json: { url: UrlHelpers.url_for(track.opus_file) }, status: :ok
    else
      render json: { error: "#{track.errors.full_messages.to_sentence}"}, status: :unprocessable_entity
    end
  end
end
