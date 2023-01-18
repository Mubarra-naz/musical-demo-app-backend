class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_action :verify_authenticity_token, only: :google_oauth2

  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in @user, event: :authentication
    else
      render json: { error: "#{@user.errors.full_messages.to_sentence}"}, status: :unprocessable_entity
    end
  end
end
