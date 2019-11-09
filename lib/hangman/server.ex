defmodule Hangman.Server do
  use GenServer

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, Hangman.Game.new_game()}
  end

  def handle_call({:make_move, guess}, _from, game) do
    {game, tally} = Hangman.Game.make_move(game, guess)
    {:reply, tally, game}
  end

  def handle_call({:tally}, _from, game) do
    {:reply, Hangman.Game.tally(game), game}
  end
end
