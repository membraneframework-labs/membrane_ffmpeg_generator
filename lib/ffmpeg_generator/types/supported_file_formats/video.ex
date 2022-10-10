defmodule Membrane.FFmpegGenerator.Types.SupportedFileFormats.Video do
  @codec_file_format [:raw, :h264]
  @container_file_format [:mp4, :mov, :wmv, :avi, :mkv]
  @pixel_formats [:I420, :I422, :I444, :RGB, :RGBA, :BGRA]

  @type codec_file_format_t ::
    unquote(
      @codec_file_format
      |> Enum.map(&inspect/1)
      |> Enum.join(" | ")
      |> Code.string_to_quoted!()
    )

  @type container_file_format_t ::
    unquote(
      @container_file_format
      |> Enum.map(&inspect/1)
      |> Enum.join(" | ")
      |> Code.string_to_quoted!()
    )

  @type pixel_formats_t ::
    unquote(
      @pixel_formats
      |> Enum.map(&inspect/1)
      |> Enum.join(" | ")
      |> Code.string_to_quoted!()
    )

  def get_supported_file_formats() do
    @codec_file_format ++ @container_file_format
  end

  def codec_file_format() do
    @codec_file_format
  end

  def container_file_format() do
    @container_file_format
  end
end
