defmodule LedsPlay.GridTest do
  use ExUnit.Case

  alias LedsPlay.Grid

  test "black grid is black" do
    grid = Grid.black(2, 2)
    assert Grid.at(grid, {0, 0}) == {0, 0, 0}
    assert Grid.at(grid, {0, 1}) == {0, 0, 0}
    assert Grid.at(grid, {1, 0}) == {0, 0, 0}
    assert Grid.at(grid, {1, 1}) == {0, 0, 0}
  end

  test "sets a color" do
    coord = {0, 0}
    grid  = Grid.black(1, 1) |> Grid.set(coord, {1, 2, 3})
    assert grid |> Grid.at(coord) == {1, 2, 3}
  end
end
