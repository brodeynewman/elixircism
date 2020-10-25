defmodule Todo.DatabaseWorker do
  use GenServer

  def init(table_name) do
    {:ok, table_name}
  end

  def start_link({table_name, worker_id}) do
    IO.puts("Starting database-worker: #{worker_id} with ets table name: #{table_name}")

    GenServer.start_link(__MODULE__, table_name, name: via(worker_id))
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
    GenServer.call(via(worker), {:insert, key, value})
  end

  def find(worker, key) do
    GenServer.call(via(worker), {:find, key})
  end

  defp via(worker) do
    Todo.Registry.via_tuple({__MODULE__, worker})
  end
end
