defmodule Membrane.FFmpegGenerator.Types.Audio do
  @type frequency_t :: non_neg_integer()
  @type sample_rate_t :: non_neg_integer()
  @type beep_factor_t :: non_neg_integer()

  @type t :: %__MODULE__{
    frequency: frequency_t(),
    sample_rate: sample_rate_t(),
    beep_factor: beep_factor_t()
  }

  @enforce_keys [:frequency, :sample_rate, :beep_factor]
  defstruct @enforce_keys
end
