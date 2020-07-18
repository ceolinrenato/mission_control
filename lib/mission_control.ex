defmodule MissionControl do
  @moduledoc false

  def main(args \\ []) do
    case parse_args(args) do
      {:ok, input_paths} ->
        parsed_paths =
          input_paths
          |> Enum.uniq()
          |> Enum.map(&MissionControl.InputParser.parse/1)

        parsed_paths
        |> Enum.reject(fn {parse_result, _} -> parse_result == :error end)
        |> Enum.map(fn {_, mission_spec} -> mission_spec end)
        |> Enum.map(&MissionControl.Mission.run/1)
        |> Enum.each(&print_result/1)

        parsed_paths
        |> Enum.reject(fn {parse_result, _} -> parse_result == :ok end)
        |> Enum.each(&print_error/1)

        terminate_process(:ok)

      {:error, error} ->
        IO.puts(error)

        terminate_process(:error)
    end
  end

  defp print_result(%{file: file, probes: probes}) do
    probe_results =
      probes
      |> Enum.map(fn %{position: {x, y, orientation}} -> "#{x} #{y} #{orientation}" end)
      |> Enum.join("\n")

    IO.puts("Results for: #{file}\n#{probe_results}\n")
  end

  defp print_error({:error, {file_path, error_reason}}) do
    IO.puts("Error at #{file_path}: #{error_reason}\n")
  end

  defp parse_args([]), do: {:error, "Missing arguments. Usage: mission_control file"}

  defp parse_args(args) do
    with {_, input_paths, []} <- OptionParser.parse(args, strict: []),
         {:invalid_paths, []} <- {:invalid_paths, invalid_paths(input_paths)} do
      {:ok, input_paths}
    else
      {:invalid_paths, invalid_paths} ->
        {:error, "Could not read files at: #{Enum.join(invalid_paths, ", ")}."}

      {_, _, invalid_args} ->
        invalid_arg_names =
          invalid_args
          |> Enum.map(fn {arg_name, _} -> arg_name end)

        {:error, "Invalid arguments: #{Enum.join(invalid_arg_names, ", ")}."}
    end
  end

  defp invalid_paths(input_paths) do
    valid_paths = Enum.filter(input_paths, &File.exists?/1)
    input_paths -- valid_paths
  end

  # For testing with ExUnit means we can't halt the process
  # When running live is desirable that the executable terminates with a non 0 status for error probing
  defp terminate_process(:error) do
    case function_exported?(Mix, :__info__, 1) do
      true ->
        :error

      _ ->
        System.halt(1)
    end
  end

  defp terminate_process(_), do: :ok
end
