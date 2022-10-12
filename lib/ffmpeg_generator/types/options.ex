defmodule Membrane.FFmpegGenerator.Types.Options do
  @moduledoc """
  Optional arguments definition for video generation.
  """
  alias Membrane.FFmpegGenerator.Types.Audio

  @default_audio_frequency 440
  @default_audio_sample_rate 44_100
  @default_audio_beep_factor 10

  @typedoc """
  Optional output file name argument.
  Represent file name under which generated file will be saved.
  If not specified, file will be saved with name generated from
  arguments passed to generation function.
  """
  @type output_file_name_t :: String.t()

  @typedoc """
  Optional output directory path argument.
  Represent path to directory in which generated file will be saved.
  If not specified, file will be saved in current working directory.
  """
  @type output_directory_path_t :: String.t()

  @typedoc """
  Optional audio caps argument.
  Represent audio specification for file generated with audio.
  If not specified, audio caps will take default values.
  """
  @type audio_caps_t :: Audio.t()

  @typedoc """
  Specify all possible optional arguments passed to multimedia generating functions.
  """
  @type possible_optional_args_t ::
          output_file_name_t() | output_directory_path_t() | output_file_name_t()

  @typedoc """
  Specify options argument for multimedia generating functions.
  Currently supported options:
  output_file_name: output_file_name_t(),
  output_directory_path: output_directory_path_t(),
  audio_caps: audio_caps_t()
  """
  @type t :: keyword(possible_optional_args_t)

  @spec get_default_audio_caps :: Audio.t()
  def get_default_audio_caps() do
    %Audio{
      frequency: @default_audio_frequency,
      sample_rate: @default_audio_sample_rate,
      beep_factor: @default_audio_beep_factor
    }
  end
end
