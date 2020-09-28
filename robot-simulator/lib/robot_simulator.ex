defmodule RobotSimulator do
  @valid_directions [:north, :east, :south, :west]
  @valid_moves ["L", "R", "A"]

  @doc """
  Create a Robot Simulator given an initial direction and position.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  def create() do
    %{direction: :north, position: {0, 0}}
  end

  def create(direction, position) do
    with :ok <- valid_direction(direction),
         :ok <- valid_position(position)
    do
      %{direction: direction, position: position}
    else
      :invalid_position -> {:error, "invalid position"}
      :invalid_direction -> {:error, "invalid direction"}
    end
  end

  defp valid_position({x, y} = position) do
    case tuple_size(position) == 2 and is_integer(x) and is_integer(y) do
      true -> :ok
      false -> :invalid_position
    end
  end

  defp valid_position(_position) do
    :invalid_position
  end

  defp valid_direction(dir) do
    case Enum.member?(@valid_directions, dir) do
      true -> :ok
      false -> :invalid_direction
    end
  end

  defp valid_move?(move) do
    case Enum.member?(@valid_moves, move) do
      true -> :ok
      false -> :invalid_direction
    end
  end

  @doc """
  Simulate the robot's movement given a string of instructions.

  Valid instructions are: "R" (turn right), "L", (turn left), and "A" (advance)
  """
  def simulate(robot, instructions) do
    update = String.next_grapheme(instructions)
    do_simulate(robot, update)
  end

  defp engine(:north, pos, "L"), do: %{direction: :west, position: pos}
  defp engine(:east, pos, "L"), do: %{direction: :north, position: pos}
  defp engine(:south, pos, "L"), do: %{direction: :east, position: pos}
  defp engine(:west, pos, "L"), do: %{direction: :south, position: pos}

  defp engine(:north, pos, "R"), do: %{direction: :east, position: pos}
  defp engine(:east, pos, "R"), do: %{direction: :south, position: pos}
  defp engine(:south, pos, "R"), do: %{direction: :west, position: pos}
  defp engine(:west, pos, "R"), do: %{direction: :north, position: pos}

  defp engine(:north = dir, {x, y}, "A"), do: %{direction: dir, position: {x, y + 1}}
  defp engine(:east = dir, {x, y}, "A"), do: %{direction: dir, position: {x + 1, y}}
  defp engine(:south = dir, {x, y}, "A"), do: %{direction: dir, position: {x, y - 1}}
  defp engine(:west = dir, {x, y}, "A"), do: %{direction: dir, position: {x - 1, y}}

  defp do_simulate(%{direction: dir, position: pos}, {move, rest}) do
    case valid_move?(move) do
      :ok ->
        new_robot = engine(dir, pos, move)
        update = String.next_grapheme(rest)

        do_simulate(new_robot, update)

      :invalid_direction -> {:error, "invalid instruction"}
    end
  end

  defp do_simulate(robot, nil), do: robot

  @doc """
  Return the robot's direction.

  Valid directions are: `:north`, `:east`, `:south`, `:west`
  """
  def direction(%{direction: dir}) do
    dir
  end

  @doc """
  Return the robot's position.
  """
  def position(%{position: position}) do
    position
  end
end
