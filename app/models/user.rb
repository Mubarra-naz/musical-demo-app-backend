class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :first_name, :last_name, presence: true
  validate :password_strength

  def password_strength
    return unless changes.keys.include?('encrypted_password')

    errors.add(:password, 'must contain one of the following characters (! @ # $ % & *).') unless /^(?=.*[%&*$!@#])/.match(password)
    errors.add(:password, 'must contain at least one lowercase character.') unless /^(?=.*[a-z])/.match(password)
    errors.add(:password, 'must contain at least one uppercase character.') unless /^(?=.*[A-Z])/.match(password)
    errors.add(:password, 'must contain at least one digit.') unless /^(?=.*[0-9])/.match(password)
    errors.add(:password, 'must be at least 8 characters long.') unless /^(?=.{8,})/.match(password)
  end
end
