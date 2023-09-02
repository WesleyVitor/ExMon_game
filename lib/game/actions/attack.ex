defmodule ExMon.Game.Actions.Attack do
  alias ExMon.Game
  alias ExMon.Game.Status
  @move_avg_power 18..25
  @move_rnd_power 10..35

  def attack_opponent(opponent, move) do
    damage = calculate_damage(move)

    opponent
    |> Game.fetch_player()
    |> Map.get(:life)
    |> calculate_total_life(damage)
    |> update_opponent_life(opponent, damage)
  end

  defp calculate_damage(:move_avg), do: Enum.random(@move_avg_power)
  defp calculate_damage(:move_rnd), do: Enum.random(@move_rnd_power)

  defp calculate_total_life(actual_life, damanage) when actual_life - damanage < 0, do: 0
  defp calculate_total_life(actual_life, damanage), do: actual_life - damanage

  defp update_opponent_life(new_life, opponent, damage) do
    opponent
    |> Game.fetch_player()
    |> Map.put(:life, new_life)
    |> update_game(opponent, damage)
  end

  defp update_game(player, opponent, damage) do
    Game.info()
    |> Map.put(opponent, player)
    |> Game.update()

    Status.print_move_message(opponent, :attack, damage)
  end
end
