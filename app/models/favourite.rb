class Favourite < ApplicationRecord
  belongs_to :user
  belongs_to :track

  validates :track_id, uniqueness: { scope: [:user_id], message: "Already marked favourite" }
end
