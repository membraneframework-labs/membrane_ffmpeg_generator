defmodule Membrane.FFmpegGenerator.Common do
  @moduledoc false

  # Module providing functions used in both, video and audio generation.

  @spec is_dir?(String.t()) :: boolean
  def is_dir?(path) do
    !String.match?(Path.basename(path), ~r/\./)
  end
end
