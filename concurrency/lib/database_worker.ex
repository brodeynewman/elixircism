defmodule Todo.DatabaseWorker do
  use GenServer

  def init(table_name) do
    {:ok, table_name}
  end

  def start(table_name) do
    IO.puts("Starting database-worker")

    GenServer.start(__MODULE__, table_name)
  end

  def handle_call({:insert, key, value}, _, table_name) do
    true = :ets.insert(table_name, {key, value})

    {:reply, true, table_name}
  end

  def handle_call({:find, key}, _, table_name) do
    value = :ets.lookup(table_name, key)

    {:reply, value, table_name}
  end

  def insert(server, key, value) do
    GenServer.call(server, {:insert, key, value})
  end

  def find(server, key) do
    GenServer.call(server, {:find, key})
  end
end
