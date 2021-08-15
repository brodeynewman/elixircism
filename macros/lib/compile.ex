defmodule Compile do
  for {i, level} <- %{1 => :err, 2 => :warn, 3 => :info} do
    def log_level(unquote(i)), do: unquote(level)
  end
end
