defmodule Hangman do
  def new_game() do
    {:ok, pid} = Supervisor.start_child(Hangman.Supervisor, [])
    IO.puts("Started a new game server with process id: ")
    IO.inspect(pid)
    pid
  end

  def tally(game_pid) do
    GenServer.call(game_pid, {:tally})
  end

  def make_move(game_pid, guess) do
    GenServer.call(game_pid, {:make_move, guess})
  end
end
