defmodule MissionControlTest do
  use ExUnit.Case, async: false

  import Mock

  describe "main/1" do
    test "returns error with invalid arguments" do
      assert MissionControl.main(["--invalid_arg"]) == :error
    end

    test "returns error when called with no arguments" do
      assert MissionControl.main() == :error
    end

    test "returns okay with valid file path" do
      file_path = "/any/path/file"

      with_mock(File, exists?: fn ^file_path -> true end, read: fn ^file_path -> {:ok, ""} end) do
        assert :ok = MissionControl.main([file_path])
      end
    end
  end
end
