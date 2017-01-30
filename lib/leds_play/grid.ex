defmodule LedsPlay.Grid do
  @enforce_keys [:width, :height]
  defstruct [:width, :height, pixels: []]

  alias LedsPlay.Grid

  def black(width, height) do
    pixels = for _ <- 1..(width*height), do: {0, 0, 0}
    %Grid{width: width, height: height, pixels: pixels}
  end

  def at(grid, coord) do
    Enum.at(grid.pixels, index_of(grid, coord))
  end

  def set(grid, coord, color) do
    pixels = List.replace_at(grid.pixels, index_of(grid, coord), color)
    %Grid{grid | pixels: pixels}
  end

  ###

  defp index_of(grid, {x, y}) do
    x + y*grid.width
  end
end
