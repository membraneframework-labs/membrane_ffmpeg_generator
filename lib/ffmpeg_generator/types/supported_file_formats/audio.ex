defmodule Membrane.FFmpegGenerator.Types.SupportedFileFormats.Audio do
  @moduledoc """
  Specify supported audio file formats.
  """

  @audio_file_formats [:mp3, :mpeg, :flac, :wav]

  @typedoc """
  Audio file formats.
  """
  @type audio_file_format_t ::
          unquote(
            @audio_file_formats
            |> Enum.map_join(" | ", &inspect/1)
            |> Code.string_to_quoted!()
          )

  @spec get_supported_file_formats() :: list(atom())
  def get_supported_file_formats() do
    @audio_file_formats
  end
end
