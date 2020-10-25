defmodule Todo.DatabaseWorker do
  use GenServer

  def init(table_name) do
    {:ok, table_name}
  end

  def start_link([table_name]) do
    IO.puts("Starting database worker")

    GenServer.start_link(__MODULE__, table_name)
  end

  def handle_call({:insert, key, value}, _, table_name) do
    true = :ets.insert(table_name, {key, value})

    {:reply, true, table_name}
  end

  def handle_call({:find, key}, _, table_name) do
    value = :ets.lookup(table_name, key)

    {:reply, value, table_name}
  end

  def insert(worker, key, value) do
    IO.inspect("Worker running insert operation: #{key}")

    GenServer.call(worker, {:insert, key, value})
  end

  def find(worker, key) do
    IO.inspect("Worker running find operation: #{key}")

    GenServer.call(worker, {:find, key})
  end
end
