defmodule Todo.Database do
  use GenServer

  @table_name :todo

  def init(_) do
    :ets.new(@table_name, [:set, :protected, :named_table])

    {:ok, nil}
  end

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def handle_call({:insert, key, value}, _, state) do
    :ets.insert(@table_name, {key, value})

    {:reply, true, state}
  end

  def handle_call({:find, key}, _, state) do
    value = :ets.lookup(@table_name, key)

    {:reply, value, state}
  end

  def insert(server, key, value) do
    GenServer.call(server, {:insert, key, value})
  end

  def find(server, key) do
    GenServer.call(server, {:find, key})
  end
end
