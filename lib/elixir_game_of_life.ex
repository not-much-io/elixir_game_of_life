defmodule GameOfLife do
  @moduledoc """
  A game of life simulator.
  """
  @type cell_state :: :a | :d
  @type pos_int :: pos_integer()
  @type non_neg :: non_neg_integer()
  @type int :: integer()
  @type cell_surrounding :: %{
    :a => non_neg,
    :d => non_neg
  }
  @typedoc """
    Grid structure:

    y [                   i
    3   [:a, :d, :d, :d], 0
    2   [:a, :a, :d, :a], 1
    1   [:d, :d, :d, :d], 2
    0   [:a, :d, :d, :d]  3
      ]x: 0   1   2   3
  """
  @type grid :: [[cell_state], ...]


  @spec new_grid(pos_int, pos_int) :: grid
  def new_grid(height, width), do: new_grid(height, width, [])
  defp new_grid(0, _w, acc),   do: acc
  defp new_grid(h, w, acc),    do: new_grid(h - 1, w, [new_grid_line(w) | acc])

  @spec cell_at(grid, int, int) :: cell_state
  def  cell_at(grid, x, y) do
    x = if x > Enum.count(grid) do -1 else x end
    y = if y > Enum.count(Enum.at(grid, 0)) do -1 else y end

    line = Enum.at(grid, x)
    Enum.at(line, y)
  end

  @spec get_cell_surrounding(grid, pos_int, pos_int) :: cell_surrounding
  def get_cell_surrounding(grid, x, y) do
    cells = get_surrounding_cells(grid, x, y)
    %{
      :a => Enum.count(cells, fn(cell) -> cell == :a end),
      :d => Enum.count(cells, fn(cell) -> cell == :d end)
    }
  end


  @spec live_cell_dies?(cell_surrounding) :: boolean
  @doc """
    Check rule 1:
      "Any live cell with fewer than two live neighbours dies,
      as if caused by under-population."
    Check rule 2:
      "Any live cell with more than three live neighbours dies,
      as if by over-population."
  """
  def live_cell_dies?(cell_surr) do
    Map.get(cell_surr, :a) < 2 || Map.get(cell_surr, :a) > 3
  end

  @spec dead_cell_lives?(cell_surrounding) :: boolean
  @doc """
    Check rule 3:
      "Any dead cell with exactly three live neighbours becomes a live cell,
      as if by reproduction."
  """
  def dead_cell_lives?(cell_surr) do
    Map.get(cell_surr, :a) == 3
  end


  @spec progress_state(grid) :: grid
  def progress_state(grid) do
    grid_height = Enum.count(grid)

    first_line  = Enum.at(grid, 0)
    grid_width  = Enum.count(first_line)

    progress_state(grid, grid_height, grid_width, [])
  end


  defp progress_state(_, 0, _, new_grid), do: Enum.reverse(new_grid)
  defp progress_state(old_grid, x, w, new_grid) do
    curr_line_new = progress_state_in_line(old_grid, x, w, [])

    progress_state(old_grid, x - 1, w, [curr_line_new | new_grid])
  end

  defp progress_state_in_line(_, _, 0, new_line), do: Enum.reverse(new_line)
  defp progress_state_in_line(old_grid, x, y, new_line) do
    curr_cell = cell_at(old_grid, x, y)
    curr_cell_surrounding = get_cell_surrounding(old_grid, x, y)

    new_cell_state =
      cond do
        curr_cell == :a && live_cell_dies?(curr_cell_surrounding) ->
          :d
        curr_cell == :d && dead_cell_lives?(curr_cell_surrounding) ->
          :a
        curr_cell == :a ->
          :a
        curr_cell == :d ->
          :d
        true ->
          :e
      end

    progress_state_in_line(old_grid, x, y - 1, [new_cell_state | new_line])
  end

  @spec new_grid_line(pos_int) :: [cell_state]
  defp new_grid_line(width),  do: new_grid_line(width, [])
  defp new_grid_line(0, acc), do: acc
  defp new_grid_line(w, acc), do: new_grid_line(w - 1, [rand_cell() | acc])

  @spec rand_cell() :: cell_state
  defp rand_cell(),           do: Enum.random([:a, :d])

  @spec get_surrounding_cells(grid, pos_int, pos_int) :: [cell_state]
  defp get_surrounding_cells(grid, x, y) do
    [
      cell_at(grid, y - 1, x - 1),    #  left_top_corner
      cell_at(grid, y - 1, x),        #  left_middle
      cell_at(grid, y - 1, x + 1),    #  left_bottom_corner

      cell_at(grid, y, x - 1),        #  middle_top
      cell_at(grid, y, x + 1),        #  middle_bottom

      cell_at(grid, y + 1, x - 1),    #  right_top_corner
      cell_at(grid, y + 1, x),        #  right_middle
      cell_at(grid, y + 1, x + 1),    #  right_bottom_corner
    ]
  end
end
