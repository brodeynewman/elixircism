defmodule Bob do
  def hey(input) do
    trimmed = String.trim(input)

    cond do
      question?(trimmed) -> "Sure."
      yelling_question?(trimmed) -> "Calm down, I know what I'm doing!"
      yelling?(trimmed) -> "Whoa, chill out!"
      empty?(trimmed) -> "Fine. Be that way!"
      true -> "Whatever."
    end
  end

  defp question?(str) do
    last = String.last(str)

    last == "?" && !yelling?(str)
  end

  defp empty?(str) do
    String.length(str) === 0
  end

  defp yelling?(str) do
    formatted = str |> format()
    capitalized = formatted |> capitalize

    String.equivalent?(formatted, capitalized) && String.length(capitalized) > 0 && capitalized != "?"
  end

  defp format(str) do
    str |> String.replace(~r/[!@#$%^&*0-9:),]/, "") |> String.trim()
  end

  defp yelling_question?(str) do
    last = String.last(str)

    yelling?(str) && last == "?"
  end

  defp capitalize(str) do
    do_capitalize(str, "")
  end

  def do_capitalize("", curr), do: curr
  def do_capitalize(left, curr) do
    {first, rest} = left |> String.capitalize() |> String.next_grapheme()

    do_capitalize(rest, curr <> first)
  end
end
