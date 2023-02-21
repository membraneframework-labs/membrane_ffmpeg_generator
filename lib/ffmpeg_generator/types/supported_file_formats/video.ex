defmodule Membrane.FFmpegGenerator.Types.SupportedFileFormats.Video do
  @moduledoc """
  Specify supported video file formats.
  """

  @codec_file_formats [:raw, :h264]
  @container_file_formats [:mp4, :mov, :wmv, :avi, :mkv]
  @pixel_formats [:I420, :I422, :I444, :RGB, :RGBA, :BGRA]

  @typedoc """
  File formats without container. Those files can only hold video without audio.
  """
  @type codec_file_format_t ::
          unquote(
            @codec_file_formats
            |> Enum.map_join(" | ", &inspect/1)
            |> Code.string_to_quoted!()
          )

  @typedoc """
  File formats with container. Those files can hold video with and without audio.
  """
  @type container_file_format_t ::
          unquote(
            @container_file_formats
            |> Enum.map_join(" | ", &inspect/1)
            |> Code.string_to_quoted!()
          )

  @typedoc """
  Supported pixel formats as atoms, compatible with Membrane.RawVideo.pixel_format.t()
  """
  @type pixel_format_t ::
          unquote(
            @pixel_formats
            |> Enum.map_join(" | ", &inspect/1)
            |> Code.string_to_quoted!()
          )

  @spec get_supported_file_formats :: list(codec_file_format_t() | container_file_format_t())
  def get_supported_file_formats() do
    @codec_file_formats ++ @container_file_formats
  end

  @spec codec_file_format :: list(codec_file_format_t())
  def codec_file_format() do
    @codec_file_formats
  end

  @spec container_file_format :: list(container_file_format_t())
  def container_file_format() do
    @container_file_formats
  end

  @spec pixel_formats :: list(pixel_format_t())
  def pixel_formats() do
    @pixel_formats
  end
end
