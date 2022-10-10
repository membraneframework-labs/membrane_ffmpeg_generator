defmodule Membrane.FFmpegGenerator.Types.SupportedFileFormats.Audio do
  @type audio_file_format_t :: :mp3, :mpeg, :flac, :wav

  def get_supported_file_formats() do
    [:mp3, :mpeg, :flac, :wav]
  end
end
