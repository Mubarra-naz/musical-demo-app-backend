require 'streamio-ffmpeg'

module FileConvertable
  extend ActiveSupport::Concern

  def convert_with_ffmpeg(file, id, ext)
    output_path = Rails.root.join("tmp","output_file_#{id}.#{ext}").to_s
    file.open(tmpdir: Rails.root.join("tmp")) do |f|
      audio = FFMPEG::Movie.new(f.path)
      audio.transcode(output_path)
    end

    output_path
  end
end
