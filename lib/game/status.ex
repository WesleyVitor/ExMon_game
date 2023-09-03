defmodule ExMon.Game.Status do
  def print_round_message(%{status: :started} = info) do
    IO.puts("\n======The game is started.======\n")
    IO.inspect(info)
    IO.puts("================================\n")
  end

  def print_round_message(%{status: :continue, turn: player} = info) do
    IO.puts("\n====== It´s #{player} turn.======\n")
    IO.inspect(info)
    IO.puts("================================\n")
  end

  def print_round_message(%{status: :game_over}) do
    IO.puts("\n====== The game is over.======\n")
    IO.puts("================================\n")
  end

  def print_invalid_move_message(move) do
    IO.puts("\n====== Invalid move: #{move}======\n")
  end

  def print_move_message(:computer, :attack, damage) do
    IO.puts("\n====== The player attacked computer dealing #{damage} damage ======\n")
  end

  def print_move_message(:player, :attack, damage) do
    IO.puts("\n====== The computer attacked player dealing #{damage} damage ======\n")
  end

  def print_move_message(player, :heal, life) do
    IO.puts("\n====== The #{player} healled itself and got #{life} points ======\n")
  end
end
