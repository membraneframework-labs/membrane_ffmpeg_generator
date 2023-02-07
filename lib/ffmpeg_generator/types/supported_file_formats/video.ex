defmodule Membrane.FFmpegGenerator.Types.SupportedFileFormats.Video do
  @moduledoc """
  Specify supported video file formats.
  """

  @codec_file_format [:raw, :h264]
  @container_file_format [:mp4, :mov, :wmv, :avi, :mkv]
  @pixel_formats [:I420, :I422, :I444, :RGB, :RGBA, :BGRA]

  @typedoc """
  File formats without container. Those files can only hold video without audio.
  """
  @type codec_file_format_t ::
          unquote(
            @codec_file_format
            |> Enum.map_join(" | ", &inspect/1)
            |> Code.string_to_quoted!()
          )

  @typedoc """
  File formats with container. Those files can hold video with and without audio.
  """
  @type container_file_format_t ::
          unquote(
            @container_file_format
            |> Enum.map_join(" | ", &inspect/1)
            |> Code.string_to_quoted!()
          )

  @typedoc """
  Supported pixel formats as atoms, compatible with Membrane.RawVideo.pixel_format.t()
  """
  @type pixel_formats_t ::
          unquote(
            @pixel_formats
            |> Enum.map_join(" | ", &inspect/1)
            |> Code.string_to_quoted!()
          )

  @spec get_supported_file_formats :: list(atom())
  def get_supported_file_formats() do
    @codec_file_format ++ @container_file_format
  end

  @spec codec_file_format :: list(atom())
  def codec_file_format() do
    @codec_file_format
  end

  @spec container_file_format :: list(atom())
  def container_file_format() do
    @container_file_format
  end

  @spec pixel_formats :: list(atom())
  def pixel_formats() do
    @pixel_formats
  end
end
