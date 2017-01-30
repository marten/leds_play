defmodule LedsPlay.GridServerTest do
  use ExUnit.Case

  alias LedsPlay.GridServer
  alias LedsPlay.Pixel

  setup do
    {:ok, server} = LedsPlay.GridServer.start_link(20, 10)
    {:ok, server: server}
  end

  test "runs a chaser", %{server: server} do
    for x <- 0..19, y <- 0..9 do
      GridServer.clear(server)
      GridServer.set(server, x, y, (x + (y*20) + 50), 255-(x + (y*20) + 50), 0)
      GridServer.render(server)
      :timer.sleep(10)
    end
  end

  test "horizontal sweep", %{server: server} do
    for x <- 0..19 do
      GridServer.clear(server)
      for y <- 0..9 do
        GridServer.set(server, x, y, (x + (y*20) + 50), 255-(x + (y*20) + 50), 0)
      end
      GridServer.render(server)
      :timer.sleep(20)
    end
  end
  
  test "merge", %{server: server} do
    GridServer.merge(server, [
          %Pixel{position: {2, 2}, color: {255, 0, 0}},
          %Pixel{position: {2, 3}, color: {0, 255, 0}},
          %Pixel{position: {2, 4}, color: {0, 0, 255}},
        ])
    GridServer.render(server)
    :timer.sleep(100)
  end

  test "strip index" do
    assert GridServer.strip_index(0,  0, 20, 10) == 0
    assert GridServer.strip_index(19, 0, 20, 10) == 19
    assert GridServer.strip_index(0,  1, 20, 10) == 39
    assert GridServer.strip_index(19, 9, 20, 10) == 180
  end

end
