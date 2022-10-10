defmodule Demo do
  alias Membrane.RawVideo
  alias Membrane.FFmpegGenerator.{VideoGenerator, AudioGenerator}
  alias Membrane.FFmpegGenerator.Types.Audio
  def demo_video_without_audio_generation do
    video_caps = %RawVideo{
      width: 1920,
      height: 1080,
      pixel_format: :I420,
      framerate: {60, 1},
      aligned: true
    }
    duration = 10
    file_format = :mov
    VideoGenerator.generate_video_without_audio(video_caps, duration, file_format)
  end
  def demo_video_with_audio_generation do
    video_caps = %RawVideo{
      width: 1920,
      height: 1080,
      pixel_format: :I420,
      framerate: {60, 1},
      aligned: true
    }
    duration = 10
    file_format = :mov
    VideoGenerator.generate_video_with_audio(video_caps, duration, file_format)
  end
  def demo_audio_generation do
    audio_caps = %Audio{
      frequency: 440,
      sample_rate: 44100,
      beep_factor: 2
    }
    duration = 10
    file_format = :mp3
    AudioGenerator.generate_audio(audio_caps, duration, file_format)
  end
end


{:ok, _path} = Demo.demo_video_without_audio_generation
{:ok, _path} = Demo.demo_video_with_audio_generation
{:ok, _path} = Demo.demo_audio_generation
