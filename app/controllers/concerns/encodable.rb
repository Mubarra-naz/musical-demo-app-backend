require 'jwt'

module Encodable
  extend ActiveSupport::Concern

  SECRET_TOKEN = Rails.application.secret_key_base
  ALGORITHM = 'HS256'.freeze
  TTL = 2.weeks.to_i.freeze

  def decode(token, isGoogleToken = false)
    if isGoogleToken
      JWT.decode(token, nil, false).first
    else
      encoded = token.split(" ").last
      JWT.decode(encoded, SECRET_TOKEN, true, { algorithm: ALGORITHM }).first
    end
  rescue JWT::ExpiredSignature, JWT::VerificationError, JWT::DecodeError => e
    render json: { error: e.message }, status: :unauthorized
  end

  def encode(payload: {id: id})
    payload[:exp] = Time.now.to_i + self.class.const_get('TTL')
    token = JWT.encode(payload, SECRET_TOKEN, ALGORITHM)

    {
      token: token,
      expiresIn: payload[:exp]
    }
  end

  def token
    request.headers["Authorization"]
  end

  def user_id
    decode(token)["user_id"]
  end

  def current_user
    user ||= User.find_by(id: user_id)
  end

  def logged_in?
    !!current_user
  end
end
