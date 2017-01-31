defmodule LedsPlay.GridServer do
  use ExActor.GenServer

  alias LedsPlay.Grid

  defstart start_link(width, height), do: initial_state(Grid.black(width, height))

  defcall get(x, y), state: grid do
    reply(Grid.at(grid, {x, y}))
  end

  defcast set(x, y, r, g, b), state: grid do
    new_state(Grid.set(grid, {x, y}, {r, g, b}))
  end

  defcast clear(), state: grid do
    new_state(Grid.clear(grid))
  end

  defcast render(), state: grid do
    data = Grid.to_pixels(grid)
    |> Enum.sort_by(fn pixel -> strip_index(pixel.pos, grid.width) end)
    |> Enum.map(fn pixel -> pixel.rgb end)

    LedsPlay.Strip.render(0, {100, data})
    noreply
  end

  ###

  def strip_index({x, y}, width) do
    if rem(y, 2) == 1 do
      x = width - x - 1
      x + (y * width)
    else
      x + (y * width)
    end
  end
end
