class Api::UsersController < ApiController
  before_action :logged_in?

  def add_favourite
    favourite = Favourite.new(user_id: current_user.id, track_id: params[:track_id])
    if favourite.save
      render json: { message: "Added to Favourites", track_id: favourite.track_id }, status: :created
    else
      render json: { message: "#{favourite.errors.full_messages.to_sentence}" }, status: :unprocessable_entity
    end
  end

  def remove_favourite
    favourite = current_user.favourites.find_by(track_id: params[:track_id])

    if favourite.destroy
      render json: { message: "Removed from favourites", track_id: params[:track_id] }, status: :ok
    else
      render json: { error: "#{favourite.errors.full_messages.to_sentence}" }, status: :unprocessable_entity
    end
  end
end
