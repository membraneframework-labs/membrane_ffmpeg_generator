alias Membrane.FFmpegGenerator.VideoGenerator
alias Membrane.FFmpegGenerator.Types.Audio
alias Membrane.RawVideo

video_caps = %RawVideo{
  width: 1920,
  height: 1080,
  framerate: {30, 1},
  pixel_format: :I420,
  aligned: true
}

duration = 10
file_format = :h264
{:ok, _output_path} = VideoGenerator.generate_video_without_audio(video_caps, duration, file_format)

# ----------
alias Membrane.FFmpegGenerator.VideoGenerator
alias Membrane.FFmpegGenerator.Types.Audio
alias Membrane.RawVideo

video_caps = %RawVideo{
  width: 3830,
  height: 2160,
  framerate: {60, 1},
  pixel_format: :RGB,
  aligned: true
}

duration = 15
file_format = :mp4

audio_caps = %Audio{
  frequency: 500,
  sample_rate: 48_000,
  beep_factor: 15
}

file_name = "awesome_video.mp4"
{:ok, current_working_directory} = File.cwd()
output_directory_path = Path.join(current_working_directory, "tmp")

options = [
  audio_caps: audio_caps,
  output_file_name: file_name,
  output_directory_path: output_directory_path
]

{:ok, _output_path} = VideoGenerator.generate_video_with_audio(video_caps, duration, file_format, options)

# ----------
