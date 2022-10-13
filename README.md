# Membrane FFmpeg Generator

[![Hex.pm](https://img.shields.io/hexpm/v/membrane_ffmpeg_generator.svg)](https://hex.pm/packages/membrane_ffmpeg_generator)
[![API Docs](https://img.shields.io/badge/api-docs-yellow.svg?style=flat)](https://hexdocs.pm/membrane_ffmpeg_generator)
[![CircleCI](https://dl.circleci.com/status-badge/img/gh/membraneframework-labs/membrane_ffmpeg_generator/tree/master.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/membraneframework-labs/membrane_ffmpeg_generator/tree/master)

This repository contains FFmpeg video and audio generator for tests, benchmarks and demos.

Check out different branches for other flavours of template.

It is part of [Membrane Multimedia Framework](https://membraneframework.org).

## Installation

The package can be installed by adding `membrane_ffmpeg_generator` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:membrane_ffmpeg_generator, "~> 0.1.0"}
  ]
end
```

## Usage
Simple generation of video without audio:
```elixir
alias Membrane.FFmpegGenerator.VideoGenerator
alias Membrane.FFmpegGenerator.Types.Audio
alias Membrane.RawVideo

video_caps = %RawVideo{
  width: 1920,
  height: 1080,
  framerate: {30, 1},
  pixel_format: :I420,
  aligned: true
}

duration = 10
file_format = :h264
{:ok, _output_path} = VideoGenerator.generate_video_without_audio(video_caps, duration, file_format)
```

More advanced video generation with audio and custom options:

## Copyright and License

Copyright 2020, [Software Mansion](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=membrane_ffmpeg_generator)

[![Software Mansion](https://logo.swmansion.com/logo?color=white&variant=desktop&width=200&tag=membrane-github)](https://swmansion.com/?utm_source=git&utm_medium=readme&utm_campaign=membrane_ffmpeg_generator)

Licensed under the [Apache License, Version 2.0](LICENSE)
