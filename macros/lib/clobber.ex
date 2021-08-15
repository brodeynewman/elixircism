defmodule Clobber do
  defmacro bind do
    quote do
      # This binds our 'leaky' variable to our parent context. Kind of dangerous.
      var!(leaky) = "This is a leaky variable. Beware."
    end
  end
end
