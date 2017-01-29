defmodule LedsPlay.Grid do
  use GenServer

  def start_link(width, height) do
    GenServer.start_link(__MODULE__, [width, height], name: __MODULE__)
  end

  def get(x, y) do
    GenServer.call(__MODULE__, {:get, x, y})
  end

  def set(x, y, r, g, b) do
    GenServer.cast(__MODULE__, {:set, x, y, r, g, b})
  end

  def render() do
    GenServer.cast(__MODULE__, {:render})
  end

  ###

  def init([width, height]) do
    grid = Enum.map(1..width, fn x ->
      Enum.map(1..height, fn y ->
        %{x: x, y: y, r: 0, g: 0, b: 0}
      end)
    end)
    {:ok, %{grid: grid}}
  end

  def handle_call({:get, x, y}, _from, %{grid: grid} = state) do
    {:reply, grid |> Enum.at(x) |> Enum.at(y), state}
  end

  def handle_cast({:set, x, y, r, g, b}, %{grid: grid} = state) do
    old_cell  = grid |> Enum.at(x) |> Enum.at(y)
    new_cell  = Map.merge(old_cell, %{r: r, g: g, b: b})
    new_col   = List.replace_at(Enum.at(grid, x), y, new_cell)
    new_grid  = List.replace_at(grid, x, new_col)
    {:noreply, Map.merge(state, %{grid: new_grid})}
  end

  def handle_cast({:render}, %{grid: grid} = state) do
    data = Enum.flat_map(grid, fn col ->
      Enum.map(col, fn %{r: r, g: g, b: b} ->
        {r, g, b}
      end)
    end)

    LedsPlay.Strip.render(0, {100, data})
    {:noreply, state}
  end
end
