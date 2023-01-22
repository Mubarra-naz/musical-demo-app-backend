require 'streamio-ffmpeg'

module FileConvertable
  extend ActiveSupport::Concern

  def convert_to_opus(file)
    output_path = "/lib/output.opus"
    file.open(tmpdir: "/lib/") do |f|
      movie = FFMPEG::Movie.new(f.path)
      movie.transcode(output_path)
    end

    output_path
  end
end
