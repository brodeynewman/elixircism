defmodule ControlFlow do
  defmacro unless(block, do: expression) do
    quote do
      if !unquote(block), do: unquote(expression)
    end
  end

  defmacro if(expression, do: truthy, else: falsy) do
    quote do
      case unquote(expression) do
        x when x in [false, nil, ""] -> unquote(falsy)
        _ -> unquote(truthy)
      end
    end
  end
  defmacro if(expression, do: truthy) do
    quote do
      case unquote(expression) do
        x when x in [false, nil] -> nil
        _ -> unquote(truthy)
      end
    end
  end

  defmacro while(expression, do: execution) do
    try do
      quote do
        for _ <- Stream.cycle([:ok]) do
          if unquote(expression) do
            unquote(execution)
          else
            throw :break
          end
        end
      end
    rescue
      _ -> nil
    end
  end
end
