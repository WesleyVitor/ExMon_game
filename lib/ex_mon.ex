defmodule ExMon do
  alias ExMon.{Player, Game}
  alias ExMon.Game.{Status, Actions}

  @computer_name "Computer"
  @computer_moves [:move_avg, :move_rnd, :move_heal]

  @doc """
    Create a player with a name and moves.
  """
  @spec create_player(String.t, atom(), atom(), atom()) :: %ExMon.Player{
          life: 100,
          moves: %{move_avg: atom(), move_heal: atom(), move_rnd: atom()},
          name: String.t
        }
  def create_player(name, move_avg, move_rnd, move_heal) do
    Player.build(name, move_avg, move_rnd, move_heal)
  end

  @doc """
    Start the game with a player.
  """
  @spec start_game(%ExMon.Player{}) :: :ok
  def start_game(player) do
    @computer_name
    |> create_player(:punch, :kick, :heal)
    |> Game.start(player)

    Status.print_round_message(Game.info())
  end

  @doc """
    Make a move by move passed.
  """
  @spec make_move(atom()) :: :ok
  def make_move(move) do
    Game.info()
    |> Map.get(:status)
    |> handle_status(move)

  end
  @doc """
    Verify the status of the game and make a move.
  """
  defp handle_status(:game_over, _move), do: Status.print_round_message(Game.info())
  defp handle_status(_other, move) do
    move
    |> Actions.fetch_move()
    |> do_move()

    computer_move(Game.info)
  end

  @doc """
    Make a move by player or computer.
  """
  defp do_move({:error, move}), do: Status.print_invalid_move_message(move)
  defp do_move({:ok, move}) do
    case move do
      :move_heal -> Actions.heal
      move -> Actions.attack(move)
    end

    Status.print_round_message(Game.info())
  end

  @doc """
    Make a move by computer.
  """
  defp computer_move(%{turn: :computer, status: :continue}) do
    move = {:ok, Enum.random(@computer_moves)}
    do_move(move)
  end
  defp computer_move(_), do: :ok
end
