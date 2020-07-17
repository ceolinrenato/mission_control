defmodule MissionControl.ProbeTest do
  @moduledoc false

  use ExUnit.Case, async: true

  describe "move/3" do
    setup do
      mission = %{
        land_size: {5, 5},
        probes: [
          %{
            position: {1, 2, "N"},
            instructions: ["L", "M", "L", "M", "L", "M", "L", "M", "M"]
          },
          %{
            position: {3, 3, "E"},
            instructions: ["M", "M", "R", "M", "M", "R", "M", "R", "R", "M"]
          }
        ]
      }

      %{mission: mission}
    end

    test "should rotate probe left", %{mission: mission} do
      assert {1, 1, "N"} = MissionControl.Probe.move(mission, {1, 1, "E"}, "L")
      assert {1, 1, "W"} = MissionControl.Probe.move(mission, {1, 1, "N"}, "L")
      assert {1, 1, "S"} = MissionControl.Probe.move(mission, {1, 1, "W"}, "L")
      assert {1, 1, "E"} = MissionControl.Probe.move(mission, {1, 1, "S"}, "L")
    end

    test "should rotate probe right", %{mission: mission} do
      assert {1, 1, "N"} = MissionControl.Probe.move(mission, {1, 1, "W"}, "R")
      assert {1, 1, "W"} = MissionControl.Probe.move(mission, {1, 1, "S"}, "R")
      assert {1, 1, "S"} = MissionControl.Probe.move(mission, {1, 1, "E"}, "R")
      assert {1, 1, "E"} = MissionControl.Probe.move(mission, {1, 1, "N"}, "R")
    end

    test "should move probe forward in y axis if NOT out of limits", %{mission: mission} do
      assert {0, 5, "N"} = MissionControl.Probe.move(mission, {0, 4, "N"}, "M")
    end

    test "should NOT move probe forward in y axis if out of limits", %{mission: mission} do
      assert {0, 5, "N"} = MissionControl.Probe.move(mission, {0, 5, "N"}, "M")
    end

    test "should move probe backward in y axis if NOT out of limits", %{mission: mission} do
      assert {0, 0, "S"} = MissionControl.Probe.move(mission, {0, 1, "S"}, "M")
    end

    test "should NOT move probe backward in y axis if out of limits", %{mission: mission} do
      assert {0, 0, "S"} = MissionControl.Probe.move(mission, {0, 0, "S"}, "M")
    end

    test "should move probe forward in x axis if NOT out of limits", %{mission: mission} do
      assert {5, 0, "E"} = MissionControl.Probe.move(mission, {4, 0, "E"}, "M")
    end

    test "should NOT move probe forward in x axis if out of limits", %{mission: mission} do
      assert {5, 0, "E"} = MissionControl.Probe.move(mission, {5, 0, "E"}, "M")
    end

    test "should move probe backward in x axis if NOT out of limits", %{mission: mission} do
      assert {0, 0, "W"} = MissionControl.Probe.move(mission, {1, 0, "W"}, "M")
    end

    test "should NOT move probe backward in x axis if out of limits", %{mission: mission} do
      assert {0, 0, "W"} = MissionControl.Probe.move(mission, {0, 0, "W"}, "M")
    end

    test "should NOT move profe if it will COLLIDE with another probe", %{mission: mission} do
      assert {2, 2, "W"} = MissionControl.Probe.move(mission, {2, 2, "W"}, "M")
    end
  end
end
