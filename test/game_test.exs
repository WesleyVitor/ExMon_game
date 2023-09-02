defmodule ExMon.GameTest do
  use ExUnit.Case

  alias ExMon.{Game, Player}

  describe "start/2" do
    test "start a game" do
      player = Player.build("Player", :punch, :kick, :heal)
      computer = Player.build("Computer", :punch, :kick, :heal)

      start = Game.start(computer, player)

      assert {:ok, _pid} = start
    end
  end

  describe "info/0" do
    test "returns the current game state" do
      player = Player.build("Player", :punch, :kick, :heal)
      computer = Player.build("Computer", :punch, :kick, :heal)

      Game.start(computer, player)
      expected_data =  %{
        computer: %ExMon.Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Computer"
        },
        player: %ExMon.Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Player"
        },
        status: :started,
        turn: :player
      }
      assert Game.info() == expected_data
    end
  end

  describe "update/1" do
    test "when is not game over, returns state of the game updated" do
      player = Player.build("Player", :punch, :kick, :heal)
      computer = Player.build("Computer", :punch, :kick, :heal)

      Game.start(computer, player)
      new_state =  %{
        computer: computer,
        player: player,
        status: :continue,
        turn: :player
      }
      Game.update(new_state)

      expected_data =  %{
        computer: %ExMon.Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Computer"
        },
        player: %ExMon.Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Player"
        },
        status: :continue,
        turn: :computer
      }

      assert Game.info() == expected_data

    end

    test "when is game over, return state of the game updated" do
      player = Player.build("Player", :punch, :kick, :heal)
      computer = Player.build("Computer", :punch, :kick, :heal)

      Game.start(computer, player)
      new_state =  %{
        computer: %Player{computer| life: 0},
        player: player,
        status: :continue,
        turn: :player
      }
      Game.update(new_state)

      expected_data =  %{
        computer: %ExMon.Player{
          life: 0,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Computer"
        },
        player: %ExMon.Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Player"
        },
        status: :game_over,
        turn: :player
      }

      assert Game.info() == expected_data
    end
  end

  describe "player/0" do
    test "return the player" do
      player = Player.build("Player", :punch, :kick, :heal)
      computer = Player.build("Computer", :punch, :kick, :heal)

      Game.start(computer, player)
      expected_data = %ExMon.Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Player"
        }
      assert Game.player() == expected_data
    end
  end
  describe "turn/0" do
    test "return the computer" do
      player = Player.build("Player", :punch, :kick, :heal)
      computer = Player.build("Computer", :punch, :kick, :heal)

      Game.start(computer, player)

      assert Game.turn == :player
    end
  end
  describe "fetch_player/1" do
    test "when key is :player, returns player struct" do
      player = Player.build("Player", :punch, :kick, :heal)
      computer = Player.build("Computer", :punch, :kick, :heal)

      Game.start(computer, player)

      expected_data = %ExMon.Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Player"
        }
      assert Game.fetch_player(:player) == expected_data
    end
    test "when key is :computer, returns computer struct" do
      player = Player.build("Player", :punch, :kick, :heal)
      computer = Player.build("Computer", :punch, :kick, :heal)

      Game.start(computer, player)

      expected_data = %ExMon.Player{
          life: 100,
          moves: %{move_avg: :punch, move_heal: :heal, move_rnd: :kick},
          name: "Computer"
        }
      assert Game.fetch_player(:computer) == expected_data
    end
  end

end
