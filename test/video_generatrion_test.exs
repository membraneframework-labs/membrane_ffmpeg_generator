defmodule Membrane.FFmpegGenerator.Test.VideoGenerationTest do
  use ExUnit.Case

  alias Membrane.FFmpegGenerator.Types.SupportedFileFormats
  alias Membrane.FFmpegGenerator.VideoGenerator
  alias Membrane.RawVideo

  @video_file_formats SupportedFileFormats.Video.get_supported_file_formats()
  @pixel_formats SupportedFileFormats.Video.pixel_formats()
  @test_video_duration 5

  {:ok, current_working_directory} = File.cwd()
  @test_output_directory Path.join(current_working_directory, "/test/tmp/fixtures")

  @hd_video %RawVideo{
    width: 1280,
    height: 720,
    framerate: {1, 1},
    pixel_format: nil,
    aligned: true
  }

  Enum.map(@video_file_formats, fn file_format ->
    Enum.map(@pixel_formats, fn pixel_format ->
      describe "video generation in #{file_format} file format, #{pixel_format} pixel format " do
        test "video without audio" do
          options = [output_directory_path: @test_output_directory]

          test_video_without_audio_generation(
            unquote(file_format),
            unquote(pixel_format),
            options
          )
        end

        case Enum.member?(SupportedFileFormats.Video.container_file_format(), file_format) do
          true ->
            test "video with audio" do
              options = [output_directory_path: @test_output_directory]

              test_video_with_audio_generation(
                unquote(file_format),
                unquote(pixel_format),
                options
              )
            end

          false ->
            nil
        end
      end
    end)
  end)

  defp test_video_without_audio_generation(file_format, pixel_format, options) do
    {:ok, output_path} =
      VideoGenerator.get_output_path(@hd_video, @test_video_duration, file_format, false, options)

    assert {:ok, ^output_path} =
             VideoGenerator.generate_video_without_audio(
               %RawVideo{@hd_video | pixel_format: pixel_format},
               @test_video_duration,
               file_format,
               options
             )

    File.rm(output_path)
  end

  defp test_video_with_audio_generation(file_format, pixel_format, options) do
    {:ok, output_path} =
      VideoGenerator.get_output_path(
        %RawVideo{@hd_video | pixel_format: pixel_format},
        @test_video_duration,
        file_format,
        true,
        options
      )

    assert {:ok, ^output_path} =
             VideoGenerator.generate_video_with_audio(
               %RawVideo{@hd_video | pixel_format: pixel_format},
               @test_video_duration,
               file_format,
               options
             )

    File.rm(output_path)
  end
end
