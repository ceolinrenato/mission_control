defmodule MissionControl.MissionTest do
  @moduledoc false

  use ExUnit.Case, async: true

  describe "run/1" do
    test "example test from challenge spec" do
      mission_specs = %{
        land_size: {5, 5},
        probes: [
          %{
            instructions: ["L", "M", "L", "M", "L", "M", "L", "M", "M"],
            position: {1, 2, "N"}
          },
          %{
            instructions: ["M", "M", "R", "M", "M", "R", "M", "R", "R", "M"],
            position: {3, 3, "E"}
          }
        ]
      }

      assert %{
               probes: [
                 %{
                   position: {1, 3, "N"}
                 },
                 %{
                   position: {5, 1, "E"}
                 }
               ]
             } = MissionControl.Mission.run(mission_specs)
    end
  end

  test "example with probe collision" do
    mission_specs = %{
      land_size: {5, 5},
      probes: [
        %{
          instructions: ["L", "M", "L", "M", "L", "M", "L", "M", "M"],
          position: {1, 2, "N"}
        },
        %{
          instructions: [
            "L",
            "L",
            "M",
            "M",
            "M",
            "M",
            "M",
            "M",
            "M",
            "L",
            "M",
            "M",
            "M",
            "M",
            "M",
            "M",
            "M",
            "M"
          ],
          position: {3, 3, "E"}
        }
      ]
    }

    assert %{
             probes: [
               %{
                 position: {1, 3, "N"}
               },
               %{
                 position: {2, 0, "S"}
               }
             ]
           } = MissionControl.Mission.run(mission_specs)
  end
end
