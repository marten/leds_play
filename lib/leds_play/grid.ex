defmodule LedsPlay.Grid do
  @enforce_keys [:width, :height]
  defstruct [:width, :height, data: []]

  alias LedsPlay.Grid
  alias LedsPlay.Pixel

  def black(width, height) do
    %Grid{width: width, height: height} |> clear
  end

  def at(grid, coord) do
    Enum.at(grid.data, index_of(grid, coord))
  end

  def set(grid, coord, color) do
    data = List.replace_at(grid.data, index_of(grid, coord), color)
    %Grid{grid | data: data}
  end

  def clear(grid) do
    data = for _ <- 1..(grid.width * grid.height), do: {0, 0, 0}
    %Grid{grid | data: data}
  end

  def to_pixels(grid) do
    grid.data
    |> Stream.with_index
    |> Enum.map(fn {rgb, idx} ->
      %Pixel{pos: coord_of(grid, idx), rgb: rgb}
    end)
  end

  ###

  defp index_of(grid, {x, y}) do
    x + y*grid.width
  end

  defp coord_of(grid, index) do
    y = div(index, grid.width)
    x = rem(index, grid.width)
    {x, y}
  end

end
