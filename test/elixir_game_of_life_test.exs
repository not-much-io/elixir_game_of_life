defmodule GameOfLifeTest do
  use ExUnit.Case
  doctest GameOfLife

  @test_grid [
    [:a, :d, :d, :d],
    [:a, :a, :d, :a],
    [:d, :d, :d, :d],
    [:a, :d, :d, :d]
  ]

  test "Create new grid works" do
    grid = GameOfLife.new_grid(1, 1)
    assert [[_]] = grid

    grid = GameOfLife.new_grid(2, 2)
    assert [[_, _], [_, _]] = grid

    grid = GameOfLife.new_grid(3, 1)
    assert [[_], [_], [_]] = grid

    grid = GameOfLife.new_grid(1, 3)
    assert [[_, _, _]] = grid
  end

  test "Can get cell" do
    cell1 = GameOfLife.cell_at(@test_grid, 0, 0)
    cell2 = GameOfLife.cell_at(@test_grid, 1, 1)
    cell3 = GameOfLife.cell_at(@test_grid, 2, 2)
    cell4 = GameOfLife.cell_at(@test_grid, 3, 3)
    cell5 = GameOfLife.cell_at(@test_grid, 1, 3)
    cell6 = GameOfLife.cell_at(@test_grid, 3, 2)
    cell7 = GameOfLife.cell_at(@test_grid, -1, -1)
    cell8 = GameOfLife.cell_at(@test_grid, -1, 3)

    assert :a == cell1
    assert :a == cell2
    assert :d == cell3
    assert :d == cell4
    assert :a == cell5
    assert :d == cell6
    assert :d == cell7
    assert :d == cell8
  end


  test "Can get cell surrounding info" do
    cell_surround1 = GameOfLife.get_cell_surrounding(@test_grid, 2, 2)
    cell_surround2 = GameOfLife.get_cell_surrounding(@test_grid, 0, 0)

    assert Map.get(cell_surround1, :d) == 6
    assert Map.get(cell_surround1, :a) == 2

    assert Map.get(cell_surround2, :d) == 4
    assert Map.get(cell_surround2, :a) == 4
  end

  test "Can check if live cell dies" do
    dies? = GameOfLife.live_cell_dies?(%{
      :a => 3,
      :d => 5
      })
    assert dies? == false

    under_population = GameOfLife.live_cell_dies?(%{
      :a => 1,
      :d => 7
      })
    assert under_population == true

    over_population = GameOfLife.live_cell_dies?(%{
      :a => 7,
      :d => 1
      })
    assert over_population == true
  end

  test "Can check if dead cell lives" do
    lives? = GameOfLife.dead_cell_lives?(%{
      :a => 3,
      :d => 5
      })
    assert lives? == true

    lives? = GameOfLife.dead_cell_lives?(%{
      :a => 2,
      :d => 6
      })
    assert lives? == false
  end

  test "Can properly progress state" do
    # [:a, :d, :d, :d]
    # [:a, :a, :d, :a]
    # [:d, :d, :d, :d]
    # [:a, :d, :d, :d]
    next_state = GameOfLife.progress_state(@test_grid)

    assert([
      [:d, :d, :d, :d],
      [:a, :a, :d, :a],
      [:a, :a, :d, :a],
      [:d, :d, :d, :a]
    ] == next_state)
  end

end
