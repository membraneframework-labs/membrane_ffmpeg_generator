defmodule Membrane.FFmpegGenerator.Test.AudioGenerationTest do
  use ExUnit.Case

  alias Membrane.FFmpegGenerator.AudioGenerator
  alias Membrane.FFmpegGenerator.Types.{Audio, SupportedFileFormats}

  @audio_file_formats SupportedFileFormats.Audio.get_supported_file_formats()
  @test_audio_duration 5
  @test_audio_format %Audio{frequency: 440, sample_rate: 44_100, beep_factor: 10}

  {:ok, current_working_directory} = File.cwd()
  @test_output_directory Path.join(current_working_directory, "/test/tmp/fixtures")

  Enum.map(@audio_file_formats, fn file_format ->
    describe "audio generation in #{file_format} file format" do
      test "audio generation" do
        options = [output_directory_path: @test_output_directory]

        test_audio_generation(
          unquote(file_format),
          options
        )
      end
    end
  end)

  defp test_audio_generation(file_format, options) do
    assert {:ok, output_path} =
             AudioGenerator.generate_audio(
               @test_audio_format,
               @test_audio_duration,
               file_format,
               options
             )

    File.rm(output_path)
  end
end
