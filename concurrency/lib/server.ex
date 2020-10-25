defmodule Todo.Server do
  use GenServer, restart: :temporary

  alias Todo.Database, as: DB

  @idle_timeout :timer.seconds(10)

  def start_link(name) do
    IO.puts("Starting server")

    GenServer.start_link(__MODULE__, nil, name: via(name))
  end

  def init(_) do
    {:ok, %{}, @idle_timeout}
  end

  def handle_call({:create_todo, person, item}, _, state) do
    case DB.find(person) do
      [] ->
        DB.insert(person, %{items: [item]})

      [{_key, %{items: items}}] ->
        DB.insert(person, %{items: [item | items]})
    end

    {:reply, true, state, @idle_timeout}
  end

  def handle_call({:get_todos, person}, _, state) do
    result = DB.find(person)

    {:reply, result, state, @idle_timeout}
  end

  def handle_info(:timeout, _) do
    IO.puts("Clearing timed-out server")
    {:stop, :normal, nil}
  end

  def get(pid, person) do
    GenServer.call(pid, {:get_todos, person})
  end

  defp via(name) do
    Todo.Registry.via_tuple({__MODULE__, name})
  end

  def create(pid, person, item) do
    GenServer.call(pid, {:create_todo, person, item})
  end
end
