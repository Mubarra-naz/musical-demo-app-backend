# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include Encodable

  respond_to :json

  skip_before_action :verify_authenticity_token

  def create
    if params[:id_token].present?

      decoded_token = decode(params[:id_token], true)
      @user = User.from_google_auth(decoded_token)
      respond_with(@user)

      render json: { error: "#{@user.errors.full_messages.to_sentence}"}, status: :unprocessable_entity if @user.errors.any?
    else
      super
    end
  end

  private

  def respond_with(resource, _options = {})
    authToken = encode(payload: { user_id: resource.id})
    render json: authToken.to_json, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: "Logged out successfully" }, status: :ok
    end
  end
end
