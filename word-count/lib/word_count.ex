defmodule WordCount do

  @spec count(String.t()) :: map
  def count(sentence) do
    sentence
      |> String.split
      |> traverse_words
  end

  def traverse_words(words) do
    Enum.reduce(words, %{}, &apply_to_map/2)
  end

  def apply_to_map(word, map) do
    Map.put_new(map, word, Map.get(map, word, 1))
  end
end
