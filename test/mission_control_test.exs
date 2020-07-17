defmodule MissionControlTest do
  use ExUnit.Case
  doctest MissionControl

  test "greets the world" do
    assert MissionControl.hello() == :world
  end
end
