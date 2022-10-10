defmodule Membrane.FFmpegGenerator.AudioGenerator do
  @moduledoc """
  Module responsible for generating audio with specified audio caps, duration and file format using FFmpeg.
  """

  alias Membrane.FFmpegGenerator.Types.Audio
  alias Membrane.FFmpegGenerator.Types.SupportedFileFormats
  alias Membrane.Time


  @spec generate_audio(Audio.t(), Time.t(), SupportedFileFormats.Audio.t(), keyword()) :: {:ok, String.t()}
  def generate_audio(audio_caps, duration, file_format, options \\ []) do
    {:ok, output_path} = get_audio_output_path(audio_caps, duration, file_format, options)

    audio_description = "sine=" <>
    "frequency=#{audio_caps.frequency}" <>
    ":sample_rate=#{audio_caps.sample_rate}" <>
    ":beep_factor=#{audio_caps.beep_factor}" <>
    ":duration=#{duration}"

    command_options = [
      "-y",
      "-f", "lavfi",
      "-i", audio_description,
      "#{output_path}"
    ]

    {result, exit_code} = System.cmd(
      "ffmpeg",
      command_options,
      stderr_to_stdout: true
    )

    case exit_code do
      0 -> {:ok, output_path}
      _other -> {:error, "Failed to create file. FFmpeg result: /n" <> result}
    end
  end

  @spec get_audio_output_path(Audio.t(), Time.t(), SupportedFileFormats.Audio.audio_file_format_t(), keyword()) :: {:ok, String.t()}
  defp get_audio_output_path(audio_caps, duration, file_format, options) do
    {:ok, file_format_string} = get_file_format_as_string(file_format)
    case Keyword.has_key?(options, :output_path) do
      true -> {:ok, Keyword.get(options, :output_path)}
      false -> {:ok, "output_audio_#{duration}s_#{audio_caps.frequency}Hz_#{audio_caps.sample_rate}_sample_rate_#{audio_caps.beep_factor}_beep_factor.#{file_format_string}"}
    end
  end

  @spec get_file_format_as_string(SupportedFileFormats.Audio.audio_file_format_t()) :: {:ok, String.t()} | {:error, String.t()}
  defp get_file_format_as_string(file_format) do
    case Enum.member?(SupportedFileFormats.Audio.get_supported_file_formats(), file_format) do
      true -> {:ok, Atom.to_string(file_format)}
      false -> {:error, "Unsupported file format: #{file_format}"}
    end
  end

end
