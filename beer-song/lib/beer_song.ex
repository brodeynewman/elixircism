defmodule BeerSong do
  def get_default_string(num) do
    "#{num} bottles of beer on the wall, #{num} bottles of beer.\nTake one down and pass it around, #{num - 1} bottle#{if num - 1 > 1, do: "s", else: "" } of beer on the wall.\n"
  end

  def get_string_for_single() do
    "1 bottle of beer on the wall, 1 bottle of beer. Take it down and pass it around, no more bottles of beer on the wall."
  end

  def get_empty_string() do
    "No more bottles of beer on the wall, no more bottles of beer. Go to the store and buy some more, 99 bottles of beer on the wall."
  end

  @doc """
  Get a single verse of the beer song
  """
  @spec verse(integer) :: String.t()
  def verse(number) do
    case number do
      1 ->
        get_string_for_single()
      0 ->
        get_empty_string()
      _ -> get_default_string(number)
    end
  end
end
