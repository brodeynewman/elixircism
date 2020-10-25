defmodule Todo.Database do
  use Supervisor

  alias Todo.DatabaseWorker, as: Worker

  @table_name :todo
  @max_workers 3

  def init(_) do
    :ets.new(@table_name, [:set, :public, :named_table])

    children = spawn_workers()

    Supervisor.init(children, strategy: :one_for_one)
  end

  defp spawn_workers do
    Enum.map(1..@max_workers, &create_worker/1)
  end

  defp create_worker(id) do
    worker_spec = {Todo.DatabaseWorker, {@table_name, id}}

    Supervisor.child_spec(worker_spec, id: id)
  end

  defp choose_worker(key) do
    found = :erlang.phash2(key, @max_workers) + 1

    IO.inspect("Using worker: #{found} for operation.")

    found
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def start_link do
    IO.puts("Starting database")

    Supervisor.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def insert(key, value) do
    key
    |> choose_worker()
    |> Worker.insert(key, value)
  end

  def find(key) do
    key
    |> choose_worker()
    |> Worker.find(key)
  end
end
