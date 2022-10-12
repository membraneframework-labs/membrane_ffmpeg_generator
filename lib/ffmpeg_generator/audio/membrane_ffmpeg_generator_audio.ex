defmodule Membrane.FFmpegGenerator.AudioGenerator do
  @moduledoc """
  Module responsible for generating audio files using FFmpeg.
  """

  alias Membrane.FFmpegGenerator.Types.{Audio, Options}
  alias Membrane.FFmpegGenerator.Types.SupportedFileFormats
  alias Membrane.Time

  @doc """
  Generates audio using FFmpeg with specified audio caps, duration, file format and additional options.
  """
  @spec generate_audio(
          Audio.t(),
          Time.t(),
          SupportedFileFormats.Audio.audio_file_format_t(),
          Options.t()
        ) ::
          {:ok, String.t()} | {:error, String.t()}
  def generate_audio(audio_caps, duration, file_format, options \\ []) do
    {:ok, output_path} = get_audio_output_path(audio_caps, duration, file_format, options)

    audio_description =
      "sine=" <>
        "frequency=#{audio_caps.frequency}" <>
        ":sample_rate=#{audio_caps.sample_rate}" <>
        ":beep_factor=#{audio_caps.beep_factor}" <>
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

    case exit_code do
      0 -> {:ok, output_path}
      _other -> {:error, "Failed to create file. FFmpeg result: /n" <> result}
    end
  end

  @spec get_audio_output_path(
          Audio.t(),
          Time.t(),
          SupportedFileFormats.Audio.audio_file_format_t(),
          Options.t()
        ) :: {:ok, String.t()}
  defp get_audio_output_path(audio_caps, duration, file_format, options) do
    {:ok, file_format_string} = get_file_format_as_string(file_format)

    file_name = Keyword.get(options, :output_file_name,
      "output_audio_#{duration}s_#{audio_caps.frequency}hz_#{audio_caps.sample_rate}_samples_#{audio_caps.beep_rate}_beeps.#{file_format_string}")

      {:ok, current_working_directory} = File.cwd()
      output_directory = Keyword.get(options, :output_directory, current_working_directory)

      :ok =
        case File.exists?(output_directory) do
          false ->
            File.mkdir_p(output_directory)

          _other ->
            :ok
        end

    {:ok, Path.join(output_directory, file_name)}
  end

  @spec get_file_format_as_string(SupportedFileFormats.Audio.audio_file_format_t()) ::
          {:ok, String.t()} | {:error, String.t()}
  defp get_file_format_as_string(file_format) do
    case Enum.member?(SupportedFileFormats.Audio.get_supported_file_formats(), file_format) do
      true -> {:ok, Atom.to_string(file_format)}
      false -> {:error, "Unsupported file format: #{file_format}"}
    end
  end
end
