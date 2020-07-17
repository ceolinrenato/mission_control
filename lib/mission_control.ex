defmodule MissionControl do
  @moduledoc false

  def main(args \\ []) do
    args
    |> parse_args()
    |> Enum.map(&MissionControl.InputParser.parse/1)
    |> IO.inspect()

    :ok
  end

  defp parse_args(args) do
    with {_, input_paths, []} <- OptionParser.parse(args, strict: []),
         {:invalid_paths, []} <- {:invalid_paths, invalid_paths(input_paths)} do
      input_paths
    else
      {:invalid_paths, invalid_paths} ->
        IO.puts("Could not read files at: #{Enum.join(invalid_paths, ", ")}.")

      {_, _, invalid_args} ->
        invalid_arg_names =
          invalid_args
          |> Enum.map(fn {arg_name, _} -> arg_name end)

        IO.puts("Invalid arguments: #{Enum.join(invalid_arg_names, ", ")}.")
    end
  end

  defp invalid_paths(input_paths) do
    valid_paths = Enum.filter(input_paths, &File.exists?/1)
    input_paths -- valid_paths
  end
end
