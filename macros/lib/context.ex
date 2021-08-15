defmodule Context do
  defmacro definfo do
    # this is in the macros' context
    IO.inspect "#{inspect __MODULE__}"

    quote do
      # This is in the caller's context
      IO.inspect "#{inspect __MODULE__}"

      def log(:info, text) do
        # this is obviously pointless, but just toying with macros
        IO.inspect("This is an info log: #{text}")
      end

      def log(:error, text) do
        # this is obviously pointless, but just toying with macros
        IO.inspect("This is an error log: #{text}")
      end
    end
  end
end
