require 'streamio-ffmpeg'

module FileConvertable
  extend ActiveSupport::Concern

  def convert_to_wav(file, id)
    output_path = Rails.root.join("tmp","output_file_#{id}.wav").to_s
    file.open(tmpdir: Rails.root.join("tmp")) do |f|
      audio = FFMPEG::Movie.new(f.path)
      audio.transcode(output_path)
    end
    puts "converted wav for track: #{id}"
    output_path
  end
end
