defmodule MissionControl.Probe do
  @moduledoc false

  @spec move(map(), {integer(), integer(), binary()}, binary()) ::
          {integer(), integer(), binary()}
  def move(_mission, {x, y, "N"}, "R") do
    {x, y, "E"}
  end

  def move(_mission, {x, y, "E"}, "R") do
    {x, y, "S"}
  end

  def move(_mission, {x, y, "S"}, "R") do
    {x, y, "W"}
  end

  def move(_mission, {x, y, "W"}, "R") do
    {x, y, "N"}
  end

  def move(_mission, {x, y, "N"}, "L") do
    {x, y, "W"}
  end

  def move(_mission, {x, y, "W"}, "L") do
    {x, y, "S"}
  end

  def move(_mission, {x, y, "S"}, "L") do
    {x, y, "E"}
  end

  def move(_mission, {x, y, "E"}, "L") do
    {x, y, "N"}
  end

  def move(mission, position, "M") do
    next_position = next_position(position)

    case can_move_to_position?(mission, next_position) do
      true ->
        next_position

      false ->
        position
    end
  end

  defp next_position({x, y, "N"}), do: {x, y + 1, "N"}

  defp next_position({x, y, "W"}), do: {x - 1, y, "W"}

  defp next_position({x, y, "S"}), do: {x, y - 1, "S"}

  defp next_position({x, y, "E"}), do: {x + 1, y, "E"}

  defp can_move_to_position?(%{land_size: land_size, probes: probes}, position) do
    !out_of_land?(land_size, position) && !any_probe_in_position?(probes, position)
  end

  defp out_of_land?({max_x, max_y}, {x, y, _}),
    do: !(Enum.member?(0..max_x, x) && Enum.member?(0..max_y, y))

  defp any_probe_in_position?(probes, position) do
    case Enum.find(probes, &probe_in_position?(&1, position)) do
      nil ->
        false

      _ ->
        true
    end
  end

  defp probe_in_position?(%{position: {probe_x, probe_y, _}}, {x, y, _}),
    do: x == probe_x && y == probe_y
end
