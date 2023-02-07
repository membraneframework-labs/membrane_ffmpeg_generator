defmodule Membrane.FFmpegGenerator.Types.Audio do
  @moduledoc """
  Define Audio struct for audio caps specification.
  """

  @typedoc """
  Audio frequency type.
  """
  @type frequency_t :: non_neg_integer()

  @typedoc """
  Audio sample rate type.
  """
  @type sample_rate_t :: non_neg_integer()

  @typedoc """
  Audio beep factor type.
  """
  @type beep_factor_t :: non_neg_integer()

  @typedoc """
  Audio caps type for specifying properties of generated multimedia file.
  """
  @type t :: %__MODULE__{
          frequency: frequency_t(),
          sample_rate: sample_rate_t(),
          beep_factor: beep_factor_t()
        }

  @enforce_keys [:frequency, :sample_rate]
  defstruct [:frequency, :sample_rate, beep_factor: 0]
end
