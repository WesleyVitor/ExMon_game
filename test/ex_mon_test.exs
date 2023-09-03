defmodule ExMonTest do
  use ExUnit.Case
  import ExUnit.CaptureIO
  alias ExMon.Player

  describe "create_player/4" do
    test "returns a player" do
      expected_data = %Player{
        life: 100,
        moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
        name: "banana"
      }

      assert ExMon.create_player("banana", :punch, :kick, :heal) == expected_data
    end
  end

  describe "start_game/1" do
    test "when game is started, return a message" do
      player = ExMon.create_player("banana", :punch, :kick, :heal)

      message =
        capture_io(fn ->
          assert ExMon.start_game(player) == :ok
        end)

      assert message =~ "The game is started."
      assert message =~ "status: :started"
    end

  end
  describe "make_move/1" do
    setup do
      player = ExMon.create_player("banana", :punch, :kick, :heal)
      capture_io(fn  ->
        ExMon.start_game(player)
      end)

      :ok
    end
    test "when the move is valid, do the move and computer do move" do
      message =
      capture_io(fn ->
        ExMon.make_move(:punch)
        end)

      assert message =~ "The player attacked computer"
      assert message =~ "status: :continue"
    end

    test "when the move is invalid, return a error message" do
      message =
      capture_io(fn ->
        ExMon.make_move(:chute)
        end)

      assert message =~ "Invalid move:"
    end

  end
end
