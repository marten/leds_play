defmodule LedsPlay.GridServer do
  use GenServer

  alias LedsPlay.Pixel

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

  def merge(server, pixels) do
    GenServer.cast(server, {:merge, pixels})
  end

  def render(server) do
    GenServer.cast(server, {:render})
  end

  ###

  def init([width, height]) do
    grid = empty_grid(width, height)
    {:ok, %{grid: grid, width: width, height: height}}
  end

  def handle_call({:get, x, y}, _from, %{grid: grid, width: width}) do
    {:reply, grid |> Enum.at(x + (y * width))}
  end

  def handle_cast({:set, x, y, r, g, b}, %{grid: grid, width: width} = state) do
    index     = grid_index(x, y, width)
    old_cell  = grid |> Enum.sort_by(fn %{x: x, y: y} -> grid_index(x, y, width) end) |> Enum.at(index)
    new_cell  = Map.merge(old_cell, %{r: r, g: g, b: b})
    new_grid  = List.replace_at(grid, index, new_cell)
    {:noreply, Map.merge(state, %{grid: new_grid})}
  end

  def handle_cast({:merge, pixels}, %{grid: grid, width: width} = state) do
    new_grid = Enum.reduce(pixels, grid, fn(pixel, grid) -> set_pixel(grid, width, pixel) end)
    {:noreply, Map.merge(state, %{grid: new_grid})}
  end

  defp set_pixel(grid, width, %Pixel{position: {x, y}, color: {r, g, b}}) do
    index    = grid_index(x, y, width)
    old_cell = grid |> Enum.sort_by(fn %{x: x, y: y} -> grid_index(x, y, width) end) |> Enum.at(index)
    new_cell = Map.merge(old_cell, %{r: r, g: g, b: b})

    List.replace_at(grid, index, new_cell)
  end

  def handle_cast({:clear}, %{width: width, height: height} = state) do
    {:noreply, Map.merge(state, %{grid: empty_grid(width, height)})}
  end

  def handle_cast({:render}, %{grid: grid, width: width, height: height} = state) do
    sorted_pixels = Enum.sort_by(grid, fn %{x: x, y: y} -> strip_index(x, y, width, height) end)
    data = Enum.map(sorted_pixels, fn %{r: r, g: g, b: b} -> {r, g, b} end)

    LedsPlay.Strip.render(0, {100, data})
    {:noreply, state}
  end

  def grid_index(x, y, width) do
    x + y*width
  end

  def strip_index(x, y, width, _height) do
    if rem(y, 2) == 1 do
      x = width - x - 1
      x + (y * width)
    else
      x + (y * width)
    end
  end

  defp empty_grid(width, height) do
    grid = for x <- 0..(width-1), y <- 0..(height-1) do
      %{x: x, y: y, r: 0, g: 0, b: 0}
    end

    Enum.sort_by(grid, fn %{x: x, y: y} -> grid_index(x, y, width) end)
  end
end
