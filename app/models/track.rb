class Track < ApplicationRecord
  include FileConvertable

  has_one_attached :audio, dependent: :destroy #mp3 file
  has_one_attached :opus, dependent: :destroy

  has_many :artist_tracks, dependent: :delete_all
  has_many :artists, class_name: 'Users', through: :artist_tracks

  validates :name, :price, presence: true
  validate :validate_audio_format

  belongs_to :sub_category, optional: true, class_name: 'Category', foreign_key: 'category_id'
  accepts_nested_attributes_for :artist_tracks, allow_destroy: true

  PUBLISH = 'publish'.freeze
  UNPUBLISH = 'unpublish'.freeze
  STATUSES = {publish: PUBLISH, unpublish: UNPUBLISH}.freeze

  enum status: STATUSES, _default: PUBLISH
  after_save_commit :save_to_opus

  # def purge_audio
  #   self.audio = nil
  # end

  def save_to_opus
    return if opus.attached? && audio.persisted?

    output_path = convert_to_opus(audio)
    opus.attach(io: File.open(output_path), filename: "#{audio.filename.to_s[0...-4]}.opus")
    save!
  end

  private

  def validate_audio_format
    errors.add(:audio, "must be attached") unless audio.attached?
    errors.add(:audio, "must be an mp3 file") if audio.attached? && !audio.content_type.in?(['audio/mpeg', 'audio/mp3'])
  end
end
