class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true
  validate :password_strength, if: :password_required?

  has_many :artist_tracks, dependent: :delete_all
  has_many :tracks, through: :artist_tracks
  has_many :favourites, dependent: :delete_all
  has_many :favourite_tracks, through: :favourites, source: :track

  USER = 'user'.freeze
  ARTIST = 'artist'.freeze
  ROLES = {user: USER, artist: ARTIST}.freeze

  enum role: ROLES, _default: USER

  def self.from_google_auth(token)
    where(email: token["email"]).first_or_create do |user|
      user.provider = "google"
      user.password = Devise.friendly_token[0, 20]
      user.first_name = token["given_name"]
      user.last_name = token["family_name"]
    end
  end

  def password_strength
    return unless changes.keys.include?('encrypted_password')

    errors.add(:password, 'must contain one of the following characters (! @ # $ % & *).') unless /^(?=.*[%&*$!@#])/.match(password)
    errors.add(:password, 'must contain at least one lowercase character.') unless /^(?=.*[a-z])/.match(password)
    errors.add(:password, 'must contain at least one uppercase character.') unless /^(?=.*[A-Z])/.match(password)
    errors.add(:password, 'must contain at least one digit.') unless /^(?=.*[0-9])/.match(password)
    errors.add(:password, 'must be at least 8 characters long.') unless /^(?=.{8,})/.match(password)
  end

  def password_required?
    return false if artist?

    super
  end
end
