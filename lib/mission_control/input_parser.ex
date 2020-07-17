defmodule MissionControl.InputParser do
  @moduledoc false

  @spec parse(binary()) :: {:ok, map()} | {:error, binary()}
  def parse(file_path) do
    {:ok, file_content} = File.read(file_path)

    [first_line | rest_of_file] = String.split(file_content, "\n", trim: true)

    with {:ok, land_size} <- parse_land_size(first_line),
         {:ok, probes} <- parse_probes(rest_of_file) do
      %{
        land_size: land_size,
        probes: probes
      }
    else
      {:error, _} = error ->
        error
    end
  end

  defp parse_land_size(line) do
    case Regex.scan(~r<^([0-9]+) ([0-9]+)$>, String.trim(line)) do
      [[_, x_max, y_max]] ->
        {:ok, {String.to_integer(x_max), String.to_integer(y_max)}}

      _ ->
        {:error, "Invalid first line! Expected the max land size (ex: 5 5)"}
    end
  end

  defp parse_probes(lines) do
    probes =
      lines
      |> Enum.chunk_every(2)
      |> Enum.map(&parse_single_probe/1)

    case Enum.filter(probes, fn {status, _} -> status == :error end) do
      [bad_probe | _rest] ->
        bad_probe

      [] ->
        {
          :ok,
          Enum.map(probes, &to_probe/1)
        }
    end
  end

  defp to_probe({:ok, {init_x, init_y, init_orientation, instructions}}) do
    %{
      initial_position: {init_x, init_y, init_orientation},
      instructions: instructions
    }
  end

  defp parse_single_probe([first_line, second_line]) do
    with {:ok, {init_x, init_y, init_orientation}} <- parse_probe_initial_position(first_line),
         {:ok, instructions} <- parse_probe_instructions(second_line) do
      {:ok, {init_x, init_y, init_orientation, instructions}}
    else
      {:error, _} = error ->
        error
    end
  end

  defp parse_probe_initial_position(line) do
    case Regex.scan(~r<^([0-9]+) ([0-9]+) ([NWSE])$>, String.trim(line)) do
      [[_, init_x, init_y, init_orientation]] ->
        {:ok,
         {
           String.to_integer(init_x),
           String.to_integer(init_y),
           init_orientation
         }}

      _ ->
        {:error, "Invalid probe position (#{line}). Use a valid position (ex: 1 3 N)"}
    end
  end

  defp parse_probe_instructions(line) do
    case Regex.scan(~r<^([LRM]+)$>, String.trim(line)) do
      [[_, instructions]] ->
        {
          :ok,
          String.graphemes(instructions)
        }

      _ ->
        {:error,
         "Invalid probe instructions (#{line}). Use valid instructions: L, R and M (ex: LLRMMLRM)"}
    end
  end
end
