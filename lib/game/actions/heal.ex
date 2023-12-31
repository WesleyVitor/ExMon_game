defmodule ExMon.Game.Actions.Heal do
  alias ExMon.Game
  alias ExMon.Game.Status
  @heal_power 18..25
  def heal_player(player) do
    player
    |> Game.fetch_player()
    |> Map.get(:life)
    |> calculate_total_life()
    |> set_life(player)
  end

  defp calculate_total_life(life), do: Enum.random(@heal_power) + life

  defp set_life(life, player) when life > 100, do: update_player_life(player, 100)
  defp set_life(life, player), do: update_player_life(player, life)

  defp update_player_life(player, life) do
    player
    |> Game.fetch_player()
    |> Map.put(:life, life)
    |> update_game(player, life)
  end

  defp update_game(player_data, player_key, life) do
    Game.info()
    |> Map.put(player_key, player_data)
    |> Game.update()

    Status.print_move_message(player_key, :heal, life)
  end
end
