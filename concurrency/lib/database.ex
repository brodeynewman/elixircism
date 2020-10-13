defmodule Todo.Database do
  use GenServer

  alias Todo.DatabaseWorker, as: Worker

  @table_name :todo
  @zero_index_max_workers 2

  def init(_) do
    :ets.new(@table_name, [:set, :public, :named_table])
    workers = spawn_workers()

    {:ok, workers}
  end

  defp spawn_workers do
    workers =
      for(i <- 0..@zero_index_max_workers, do: i)
      |> Enum.reduce(%{}, &do_spawn_worker(&1, &2))

    workers
  end

  defp do_spawn_worker(i, acc) do
    Map.put(acc, i, create_worker())
  end

  defp create_worker do
    {:ok, pid} = Worker.start(@table_name)

    pid
  end

  defp choose_worker(key, workers) do
    ind = :erlang.phash2(key, 3)

    workers[ind]
  end

  def start do
    IO.puts("Starting database")

    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def handle_call({:insert, key, value}, _, state) do
    pid = choose_worker(key, state)

    Worker.insert(pid, key, value)

    {:reply, true, state}
  end

  def handle_call({:find, key}, _, state) do
    pid = choose_worker(key, state)

    value = Worker.find(pid, key)

    {:reply, value, state}
  end

  def insert(key, value) do
    GenServer.call(__MODULE__, {:insert, key, value})
  end

  def find(key) do
    GenServer.call(__MODULE__, {:find, key})
  end
end
