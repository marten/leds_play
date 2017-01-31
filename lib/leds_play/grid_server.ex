defmodule LedsPlay.GridServer do
  use GenServer

  alias LedsPlay.Grid

  def start_link(width, height) do
    GenServer.start_link(__MODULE__, [width, height])
  end

  def get(server, x, y) do
    GenServer.call(server, {:get, x, y})
  end

  def set(server, x, y, r, g, b) do
    GenServer.cast(server, {:set, x, y, r, g, b})
  end

  def clear(server) do
    GenServer.cast(server, {:clear})
  end

  def render(server) do
    GenServer.cast(server, {:render})
  end

  ###

  def init([width, height]) do
    grid = Grid.black(width, height)
    {:ok, grid}
  end

  def handle_call({:get, x, y}, _from, grid) do
    {:reply, Grid.at(grid, {x, y})}
  end

  def handle_cast({:set, x, y, r, g, b}, grid) do
    {:noreply, Grid.set(grid, {x, y}, {r, g, b})}
  end

  def handle_cast({:clear}, grid) do
    {:noreply, Grid.clear(grid)}
  end

  def handle_cast({:render}, grid) do
    data = Grid.pixels(grid)
    |> Enum.sort_by(fn pixel -> strip_index(pixel.pos, grid.width) end)
    |> Enum.map(fn pixel -> pixel.rgb end)

    LedsPlay.Strip.render(0, {100, data})
    {:noreply, grid}
  end

  def strip_index({x, y}, width) do
    if rem(y, 2) == 1 do
      x = width - x - 1
      x + (y * width)
    else
      x + (y * width)
    end
  end
end
