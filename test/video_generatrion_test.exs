defmodule Membrane.FFmpegGenerator.Test.VideoGeneration do
  use ExUnit.Case

  alias Membrane.RawVideo
  alias Membrane.FFmpegGenerator.VideoGenerator
  alias Membrane.FFmpegGenerator.Types.SupportedFileFormats

  @video_file_formats SupportedFileFormats.Video.get_supported_file_formats()
  @test_video_duration 5

  {:ok, current_working_directory} = File.cwd()
  @test_output_directory Path.join(current_working_directory, "/test/tmp/fixtures")

  @hd_video %RawVideo{
    width: 1280,
    height: 720,
    framerate: {1, 1},
    pixel_format: :I420,
    aligned: true
  }

  Enum.map(@video_file_formats, fn file_format ->
    describe "Checks video generation in #{file_format} file format" do
      test "video without audio" do
        options = [output_directory: @test_output_directory]
        test_video_without_audio_generation(unquote(file_format), options)
      end

      case Enum.member?(SupportedFileFormats.Video.container_file_format(), file_format) do
        true ->
          test "video with audio" do
            options = [output_directory: @test_output_directory]
            test_video_with_audio_generation(unquote(file_format), options)
          end
        false -> nil
      end
    end
  end
  )

  defp test_video_without_audio_generation(file_format, options) do
    {:ok, output_path} = VideoGenerator.get_output_path(@hd_video, @test_video_duration, file_format, false, options)
    assert {:ok, ^output_path} =
      VideoGenerator.generate_video_without_audio(@hd_video, @test_video_duration, file_format, options)
    File.rm(output_path)
  end

  defp test_video_with_audio_generation(file_format, options) do
    {:ok, output_path} = VideoGenerator.get_output_path(@hd_video, @test_video_duration, file_format, true, options)
    assert {:ok, ^output_path} =
      VideoGenerator.generate_video_with_audio(@hd_video, @test_video_duration, file_format, options)
    File.rm(output_path)
  end
end
