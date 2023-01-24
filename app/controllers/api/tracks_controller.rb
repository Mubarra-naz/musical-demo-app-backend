class Api::TracksController < ApiController
  def index
    @tracks = Track.published
    render json: TrackSerializer.new(@tracks)
  end
end
