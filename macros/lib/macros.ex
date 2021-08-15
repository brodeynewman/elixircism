defmodule Macros do
  require ControlFlow
  require Clobber
  require Context
  Context.definfo

  alias Compile

  def unless do
    ControlFlow.unless 1 == 5 do
      "This works mate"
    end
  end

  def examine do
    IO.inspect Compile.log_level(2)

    quote do
      IO.inspect Compile.log_level()
    end
  end

  def context do
    log(:info, "Nice, this works")
    log(:error, "Nice, this works")
  end

  def clob do
    Clobber.bind
    leaky
  end

  def if do
    ControlFlow.if "" do
      "foo"
    else
      "bar"
    end
  end

  def while do
    num = 0

    ControlFlow.while num < 5 do
      IO.puts "INC"
    end
  end
end
