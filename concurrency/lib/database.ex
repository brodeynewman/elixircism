defmodule Todo.Database do
  use Supervisor

  @table_name :todo

  defp poolboy_config do
    [
      name: {:local, __MODULE__},
      worker_module: Todo.DatabaseWorker,
      size: 3,
      max_overflow: 2
    ]
  end

  def init(_) do
    :ets.new(@table_name, [:set, :public, :named_table])

    children = [
      :poolboy.child_spec(__MODULE__, poolboy_config(), [@table_name])
    ]

    Supervisor.init(children, strategy: :one_for_one)
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

    opts = [strategy: :one_for_one, name: PoolboyApp.Supervisor]

    Supervisor.start_link(__MODULE__, opts)
  end

  def insert(key, value) do
    :poolboy.transaction(
      __MODULE__,
      fn pid ->
        Todo.DatabaseWorker.insert(pid, key, value)
      end
    )
  end

  def find(key) do
    :poolboy.transaction(
      __MODULE__,
      fn pid ->
        Todo.DatabaseWorker.find(pid, key)
      end
    )
  end
end
