desc "Convert all mp3 files to wav"
task mp3_to_wav_conversion: :environment do
  Track.find_each do |track|
    track.save_wav_file
  end
end
