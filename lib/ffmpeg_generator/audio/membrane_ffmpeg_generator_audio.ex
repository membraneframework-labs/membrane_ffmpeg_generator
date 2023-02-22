defmodule Membrane.FFmpegGenerator.AudioGenerator do
  @moduledoc """
  Module responsible for generating audio files using FFmpeg.
  """

  alias Membrane.FFmpegGenerator.Common
  alias Membrane.FFmpegGenerator.Types.{Audio, Options}
  alias Membrane.FFmpegGenerator.Types.SupportedFileFormats
  alias Membrane.Time

  @doc """
  Generates audio using FFmpeg with specified audio format, duration, file format and additional options.
  # Values
  - audio_format: specify generated audio parameters
  - duration: length of generated audio file
  - file_format: format of generated file, such as :mp3, :mpeg, :flac, :wav
  - options: other optional arguments, e.x. output_path
  """
  @spec generate_audio(
          Audio.t(),
          Time.t(),
          SupportedFileFormats.Audio.audio_file_format_t(),
          Options.t()
        ) ::
          {:ok, String.t()} | {:error, String.t()}
  def generate_audio(audio_format, duration, file_format, options \\ []) do
    {:ok, output_path} = get_audio_output_path(audio_format, duration, file_format, options)

    audio_description =
      "sine=" <>
        "frequency=#{audio_format.frequency}" <>
        ":sample_rate=#{audio_format.sample_rate}" <>
        ":beep_factor=#{audio_format.beep_factor}" <>
        ":duration=#{duration}"

    command_options = [
      "-y",
      "-f",
      "lavfi",
      "-i",
      audio_description,
      "#{output_path}"
    ]

    {result, exit_code} =
      System.cmd(
        "ffmpeg",
        command_options,
        stderr_to_stdout: true
      )

    if exit_code == 0 do
      {:ok, output_path}
    else
      {:error, "Failed to create file. FFmpeg result: /n" <> result}
    end
  end

  @spec get_audio_output_path(
          Audio.t(),
          Time.t(),
          SupportedFileFormats.Audio.audio_file_format_t(),
          Options.t()
        ) :: {:ok, String.t()}
  defp get_audio_output_path(audio_format, duration, file_format, options) do
    {:ok, file_format_string} = get_file_format_as_string(file_format)
    {:ok, current_working_directory} = File.cwd()

    path =
      Keyword.get(
        options,
        :output_path,
        current_working_directory
      )

    path =
      if Common.is_dir?(path) do
        Path.join(
          path,
          "output_audio_#{duration}s_#{audio_format.frequency}hz_#{audio_format.sample_rate}_samples_#{audio_format.beep_factor}_beeps.#{file_format_string}"
        )
      else
        path
      end

    unless File.exists?(Path.dirname(path)) do
      :ok = File.mkdir_p(Path.dirname(path))
    end

    {:ok, path}
  end

  @spec get_file_format_as_string(SupportedFileFormats.Audio.audio_file_format_t()) ::
          {:ok, String.t()} | {:error, String.t()}
  defp get_file_format_as_string(file_format) do
    if Enum.member?(SupportedFileFormats.Audio.get_supported_file_formats(), file_format) do
      {:ok, Atom.to_string(file_format)}
    else
      {:error, "Unsupported file format: #{file_format}"}
    end
  end
end
