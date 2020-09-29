defmodule ListOps do
  # Please don't use any external modules (especially List or Enum) in your
  # implementation. The point of this exercise is to create these basic
  # functions yourself. You may use basic Kernel functions (like `Kernel.+/2`
  # for adding numbers), but please do not use Kernel functions for Lists like
  # `++`, `--`, `hd`, `tl`, `in`, and `length`.

  def count(l) do
    do_count(0, l)
  end

  defp do_count(n, [_ | tail]) do
    do_count(n + 1, tail)
  end

  defp do_count(n, []), do: n

  def reverse(l) do
    do_reverse(l, [])
  end

  defp do_reverse([head | tail], l) do
    do_reverse(tail, [head | l])
  end

  defp do_reverse([], l), do: l

  def map(l, f) do
    do_map(l, f, [])
  end

  defp do_map([next | tail], f, acc) do
    new = f.(next)

    do_map(tail, f, [new | acc])
  end

  defp do_map([], _f, acc), do: reverse(acc)

  def filter(l, f) do
    do_filter(l, f, [])
  end

  defp do_filter([next | tail], f, acc) do
    case f.(next) do
      true -> do_filter(tail, f, [next | acc])
      false -> do_filter(tail, f, acc)
    end
  end

  defp do_filter([], _f, acc), do: reverse(acc)

  def reduce(l, acc, f) do
    do_reduce(l, acc, f)
  end

  defp do_reduce([next | tail], acc, f) do
    next_acc = f.(next, acc)
    do_reduce(tail, next_acc, f)
  end

  defp do_reduce([], acc, _f), do: acc

  def append(a, b) do
    reversed = reverse(a)

    do_append(reversed, b)
  end

  defp do_append(acc, [next | tail]) do
    do_append([next | acc], tail)
  end

  defp do_append(a, []), do: reverse(a)

  def concat(ll) do
    do_concat(ll, [])
  end

  defp do_concat([head | rest], acc) do
    next = do_concat(head, [])

    do_concat(rest, [next | acc])
  end

  defp do_concat([], [head | tail]) do

  end

  defp do_concat(v, _acc), do: v
end
