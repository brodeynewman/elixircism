defmodule RnaTranscription do
  @dna_mapping %{"G" => "C", "C" => "G", "T" => "A", "A" => "U"}

  def get_dna_structure(char) do
    Map.get(@dna_mapping, char)
  end

  def to_rna(dna) do
    dna
      |> String.codepoints
      |> Enum.map(&get_dna_structure/1)
      |> Enum.join
  end
end
