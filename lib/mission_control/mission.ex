defmodule MissionControl.Mission do
  @moduledoc false

  @spec run(map()) :: map()
  def run(%{probes: probes} = mission_specs) do
    probes
    |> Enum.with_index()
    |> Enum.reduce(mission_specs, &(probe_run(&2, &1)))
  end

  defp probe_run(%{probes: probes} = mission, {_, probe_index}) do
    %{position: position, instructions: instructions} = get_in(probes, [Access.at(probe_index)])

    case List.pop_at(instructions, 0) do
      {nil, []} ->
        mission

      {instruction, []} ->
        put_in(mission, [:probes, Access.at(probe_index)], %{
          position: MissionControl.Probe.move(mission, position, instruction),
          instructions: []
        })

      {instruction, instructions_left} ->
        new_mission =
          put_in(mission, [:probes, Access.at(probe_index)], %{
            position: MissionControl.Probe.move(mission, position, instruction),
            instructions: instructions_left
          })

        probe_run(new_mission, {nil, probe_index})
    end
  end
end
