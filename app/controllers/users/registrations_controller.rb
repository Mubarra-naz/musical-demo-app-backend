# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :json

  skip_before_action :verify_authenticity_token

  private

  def respond_with(resource, _options = {})
    if resource.persisted?
      render json: { message: "Signed up successfully", data: UserSerializer.new(resource).serializable_hash[:data]}, status: :ok
    else
      render json: { error: "#{resource.errors.full_messages.to_sentence}"}, status: :unprocessable_entity
    end
  end
end
