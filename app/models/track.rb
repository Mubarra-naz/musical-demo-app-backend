class Track < ApplicationRecord
  include FileConvertable

  has_one_attached :audio, dependent: :destroy #mp3 file
  has_one_attached :wav_file, dependent: :destroy

  has_many :artist_tracks, dependent: :delete_all
  has_many :artists, class_name: 'Users', through: :artist_tracks

  validates :name, :price, presence: true
  validate :validate_audio_format

  belongs_to :sub_category, optional: true, class_name: 'Category', foreign_key: 'category_id'
  accepts_nested_attributes_for :artist_tracks, allow_destroy: true

  PUBLISH = 'publish'.freeze
  UNPUBLISH = 'unpublish'.freeze
  STATUSES = {publish: PUBLISH, unpublish: UNPUBLISH}.freeze

  scope :eager_load_associations, -> { includes(:wav_file_blob, artist_tracks: [:artist], sub_category: :category) }
  scope :published, -> { eager_load_associations.publish }

  enum status: STATUSES, _default: PUBLISH

  after_save_commit :save_wav_file

  # def purge_audio
  #   self.audio = nil
  # end

  def save_wav_file
    return if wav_file.attached? && audio.persisted?

    output_path = convert_to_wav(audio, id)
    wav_file.attach(io: File.open(output_path), filename: "#{audio.filename.to_s[0...-4]}.wav")
    puts "saving wav for track: #{id}"
    save!
    File.delete(output_path)
  end

  private

  def validate_audio_format
    errors.add(:audio, "must be attached") unless audio.attached?
    errors.add(:audio, "must be an mp3 file") if audio.attached? && !audio.content_type.in?(['audio/mpeg', 'audio/mp3'])
  end
end
