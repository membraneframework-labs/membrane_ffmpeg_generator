defmodule Membrane.FFmpegGenerator.Types.Options do
  @moduledoc """
  Optional arguments definition for video generation.
  """
  alias Membrane.FFmpegGenerator.Types.Audio

  @default_audio_frequency 440
  @default_audio_sample_rate 44_100

  @typedoc """
  Optional output file name argument.
  Represents file name under which generated file will be saved.
  If not specified, file will be saved with name generated from
  arguments passed to generation function. If is path to directory,
  generated file will be saved in specified directory with automatically
  generated file name.
  """
  @type output_path_t :: String.t()

  @typedoc """
  Optional audio format argument.
  Represents audio specification for file generated with audio.
  If not specified, audio format will take default values.
  """
  @type audio_format_t :: Audio.t()

  @typedoc """
  Specify all possible optional arguments passed to multimedia generating functions.
  """
  @type possible_optional_args_t ::
          output_path_t() | audio_format_t()

  @typedoc """
  Specify options argument for multimedia generating functions.
  Currently supported options:
  output_path: output_path_t(),
  audio_format: audio_format_t()
  """
  @type t :: keyword(possible_optional_args_t)

  @spec get_default_audio_format :: Audio.t()
  def get_default_audio_format() do
    %Audio{
      frequency: @default_audio_frequency,
      sample_rate: @default_audio_sample_rate
    }
  end
end
