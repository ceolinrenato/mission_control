defmodule MissionControl.InputParserTest do
  @moduledoc false
  use ExUnit.Case, async: false

  import Mock

  describe "parse/1" do
    setup do
      file_content = ~s"""
      5 5
      1 2 N
      LMLMLMLMM
      3 3 E
      MMRMMRMRRM

      """

      %{file_content: file_content}
    end

    test "should return the parsed content with valid file", %{file_content: file_content} do
      file_path = "/any/path/file"

      with_mock(File, read: fn ^file_path -> {:ok, file_content} end) do
        assert %{
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
               } = MissionControl.InputParser.parse(file_path)
      end
    end
  end
end
