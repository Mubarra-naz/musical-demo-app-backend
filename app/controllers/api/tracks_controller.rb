class Api::TracksController < ApiController
  before_action :logged_in?, :get_track, only: [:download]

  def index
    @tracks = Track.published
    @favourite_tracks = current_user.favourite_tracks if token.present?
    render json: TrackSerializer.new(@tracks, params: { favourite_tracks: @favourite_tracks })
  end

  def download
    @track.save_opus_file
    if @track.opus_file.attached?
      render json: { url: UrlHelpers.url_for(@track.opus_file) }, status: :ok
    else
      render json: { error: "#{@track.errors.full_messages.to_sentence}"}, status: :unprocessable_entity
    end
  end

  private

  def get_track
    @track = Track.find(params[:id])
  end
end
