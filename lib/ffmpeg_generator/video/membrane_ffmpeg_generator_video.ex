defmodule Membrane.FFmpegGenerator.VideoGenerator do
  @moduledoc """
  Module responsible for generating video files using FFmpeg.
  """
  alias Membrane.FFmpegGenerator.Common
  alias Membrane.FFmpegGenerator.Types.{Audio, Options}
  alias Membrane.FFmpegGenerator.Types.SupportedFileFormats
  alias Membrane.{RawVideo, Time}

  @doc """
  Generates video without audio with specified video format, duration, file format and additional options using FFmpeg.

  # Values
  - video_format: specify generated video parameters
  - duration: length of generated video
  - file_format: format of generated file, e.x. :mp4, :h264, :mov, :raw, :mkv
  - options: other optional arguments, e.x. output_path
  """
  @spec generate_video_without_audio(
          RawVideo.t(),
          Time.t(),
          SupportedFileFormats.Video.codec_file_format_t()
          | SupportedFileFormats.Video.container_file_format_t(),
          Options.t()
        ) ::
          {:ok, String.t()} | {:error, String.t()}
  def generate_video_without_audio(video_format, duration, file_format, options \\ []) do
    {:ok, output_path, framerate, ffmpeg_pixel_format} =
      get_arguments_values(video_format, duration, file_format, false, options)

    video_description =
      "testsrc=duration=#{duration}" <>
        ":size=#{video_format.width}x#{video_format.height}" <>
        ":rate=#{framerate}," <>
        "format=#{ffmpeg_pixel_format}"

    command_options =
      case file_format do
        :raw ->
          [
            "-y",
            "-f",
            "lavfi",
            "-i",
            video_description,
            "-f",
            "rawvideo",
            "#{output_path}"
          ]

        _other ->
          [
            "-y",
            "-f",
            "lavfi",
            "-i",
            video_description,
            "#{output_path}"
          ]
      end

    {result, exit_code} =
      System.cmd(
        "ffmpeg",
        command_options,
        stderr_to_stdout: true
      )

    if exit_code == 0 do
      {:ok, output_path}
    else
      {:error, "Failed to generate the file. FFmpeg result: \n" <> result}
    end
  end

  @doc """
  Generates video without audio with specified video format, duration, file format and additional options using FFmpeg.
  Audio format can be specified in options.

  # Values
  - video_format: specify generated video parameters
  - duration: length of generated video
  - file_format: format of generated file, e.x. :mp4, :h264, :mov, :raw, :mkv
  - options: other optional arguments, e.x. output_path, audio_format
  """
  @spec generate_video_with_audio(
          RawVideo.t(),
          Time.t(),
          SupportedFileFormats.Video.codec_file_format_t()
          | SupportedFileFormats.Video.container_file_format_t(),
          Options.t()
        ) :: {:ok, String.t()} | {:error, String.t()}
  def generate_video_with_audio(video_format, duration, file_format, options \\ []) do
    {:ok, output_path, framerate, ffmpeg_pixel_format, audio_format} =
      get_arguments_values(video_format, duration, file_format, true, options)

    video_description =
      "testsrc=duration=#{duration}" <>
        ":size=#{video_format.width}x#{video_format.height}" <>
        ":rate=#{framerate}," <>
        "format=#{ffmpeg_pixel_format}"

    audio_description =
      "sine=" <>
        "frequency=#{audio_format.frequency}" <>
        ":sample_rate=#{audio_format.sample_rate}" <>
        ":beep_factor=#{audio_format.beep_factor}" <>
        ":duration=#{duration}"

    filter = "[0][0]amerge=inputs=2"

    command_options = [
      "-y",
      "-f",
      "lavfi",
      "-i",
      audio_description,
      "-f",
      "lavfi",
      "-i",
      video_description,
      "-filter_complex",
      "#{filter}",
      "-shortest",
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
      {:error, "Failed to generate the file. FFmpeg result: \n" <> result}
    end
  end

  @spec get_output_path(
          RawVideo.t(),
          Time.t(),
          SupportedFileFormats.Video.codec_file_format_t()
          | SupportedFileFormats.Video.container_file_format_t(),
          boolean(),
          Options.t()
        ) :: {:ok, String.t()}
  def get_output_path(format, duration, file_format, has_audio?, options) do
    {:ok, current_working_directory} = File.cwd()

    path =
      Keyword.get(
        options,
        :output_path,
        current_working_directory
      )

    path =
      if Common.is_dir?(path) do
        Path.join(path, get_output_file_name(format, duration, file_format, has_audio?))
      else
        path
      end

    unless File.exists?(Path.dirname(path)) do
      :ok = File.mkdir_p(Path.dirname(path))
    end

    {:ok, path}
  end

  @spec get_output_file_name(
          RawVideo.t(),
          Time.t(),
          SupportedFileFormats.Video.codec_file_format_t()
          | SupportedFileFormats.Video.container_file_format_t(),
          boolean()
        ) :: String.t()
  defp get_output_file_name(format, duration, file_format, has_audio?) do
    {:ok, file_format_string} = get_file_format_as_string(file_format)
    {:ok, framerate} = get_framerate_as_float(format.framerate)

    if has_audio? do
      "output_video_with_audio_#{duration}s_#{format.width}x#{format.height}_#{round(framerate)}fps.#{file_format_string}"
    else
      "output_video_#{duration}s_#{format.width}x#{format.height}_#{round(framerate)}fps.#{file_format_string}"
    end
  end

  defp get_arguments_values(video_format, duration, file_format, has_audio?, options) do
    {:ok, output_path} = get_output_path(video_format, duration, file_format, has_audio?, options)
    {:ok, framerate} = get_framerate_as_float(video_format.framerate)
    {:ok, ffmpeg_pixel_format} = get_ffmpeg_pixel_format(video_format.pixel_format)

    if has_audio? do
      {:ok, audio_format} = get_audio_format(options)
      {:ok, output_path, framerate, ffmpeg_pixel_format, audio_format}
    else
      {:ok, output_path, framerate, ffmpeg_pixel_format}
    end
  end

  @spec get_ffmpeg_pixel_format(SupportedFileFormats.Video.pixel_format_t()) :: {:ok, String.t()}
  defp get_ffmpeg_pixel_format(format) do
    case format do
      :I420 -> {:ok, "yuv420p"}
      :I422 -> {:ok, "yuv422p"}
      :I444 -> {:ok, "yuv444p"}
      :RGB -> {:ok, "rgb24"}
      :RGBA -> {:ok, "rgba"}
      :BGRA -> {:ok, "bgra"}
    end
  end

  @spec get_file_format_as_string(
          SupportedFileFormats.Video.codec_file_format_t()
          | SupportedFileFormats.Video.container_file_format_t()
        ) ::
          {:ok, String.t()} | {:error, String.t()}
  defp get_file_format_as_string(file_format) do
    case Enum.member?(SupportedFileFormats.Video.get_supported_file_formats(), file_format) do
      true -> {:ok, Atom.to_string(file_format)}
      false -> {:error, "Unsupported file format."}
    end
  end

  @spec get_audio_format(Options.t()) :: {:ok, Audio}
  defp get_audio_format(options) do
    {:ok, Keyword.get(options, :audio_format, Options.get_default_audio_format())}
  end

  @spec get_framerate_as_float(RawVideo.framerate_t()) :: {:ok, float()}
  defp get_framerate_as_float(framerate) do
    {:ok, elem(framerate, 0) / elem(framerate, 1)}
  end
end
