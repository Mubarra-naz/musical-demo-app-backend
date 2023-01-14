# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include Encodable

  respond_to :json

  private

  def respond_with(resource, _options = {})
    authToken = encode(payload: { user_id: resource.id})
    render json: UserSerializer.new(resource, { params: {token: authToken}}).serialized_json, status: :ok
  end

  def respond_to_on_destroy
    if current_user
      render json: { message: "Logged out successfully" }, status: :ok
    else
      render json: { error: "couldn't find an active session" }, status: :unauthorized
    end
  end
end
