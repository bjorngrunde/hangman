defmodule GameTest do
  use ExUnit.Case
  alias Hangman.Game

  test "new_game() returns structure" do
    game = Game.new_game()

    assert game.turns_left == 7
    assert game.game_state == :initializing
    assert length(game.letters) > 0
  end

  test "state isn't changed for :won or :lost game" do
    for state <- [:won, :lost] do
      game = Game.new_game() |> Map.put(:game_state, state)
      assert {^game, _} = Game.make_move(game, "x")
    end
  end

  test "first occurence of letter is not already used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state != :already_used
  end

  test "second occurence of letter is already used" do
    game = Game.new_game()
    {game, _tally} = Game.make_move(game, "x")
    {game, _tally} = Game.make_move(game, "x")
    assert game.game_state == :already_used
  end

  test "a good guess is recognized" do
    game = Game.new_game("wibble")
    {game, _tally} = Game.make_move(game, "w")
    assert game.game_state == :good_guess
    assert game.turns_left == 7
  end

  test "a guess word is a won game" do
    assert_game_moves("swagg", [
      {"s", :good_guess, 7, "____"},
      {"w", :good_guess, 7, "____"},
      {"a", :good_guess, 7, "____"},
      {"g", :won, 7, "____"}
    ])
  end

  test "bad guess is recognized" do
    assert_game_moves("wiggle", [
      {"a", :bad_guess, 6, "____"},
      {"w", :good_guess, 6, "____"},
      {"i", :good_guess, 6, "____"},
      {"r", :bad_guess, 5, "____"},
      {"l", :good_guess, 5, "____"},
      {"g", :good_guess, 5, "____"},
      {"e", :won, 5, "____"}
    ])
  end

  test "lost game is recognized" do
    assert_game_moves("paint", [
      {"q", :bad_guess, 6, "____"},
      {"b", :bad_guess, 5, "____"},
      {"c", :bad_guess, 4, "____"},
      {"d", :bad_guess, 3, "____"},
      {"e", :bad_guess, 2, "____"},
      {"f", :bad_guess, 1, "____"},
      {"g", :lost, 1, "____"}
    ])
  end

  def assert_game_moves(word, moves) do
    Enum.reduce(
      moves,
      Game.new_game(word),
      fn {guess, state, turns_left, word}, game ->
        {game, _} = Game.make_move(game, guess)
        assert game.game_state == state
        assert game.turns_left == turns_left
        game
      end
    )
  end
end
