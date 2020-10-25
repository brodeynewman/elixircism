defmodule Todo.Server do
  use GenServer, restart: :temporary

  alias Todo.Database, as: DB

  def start_link(name) do
    IO.puts("Starting server")

    GenServer.start_link(__MODULE__, nil, name: via(name))
  end

  def init(_) do
    {:ok, %{}}
  end

  def handle_call({:create_todo, person, item}, _, state) do
    case DB.find(person) do
      [] ->
        DB.insert(person, %{items: [item]})

      [{_key, %{items: items}}] ->
        DB.insert(person, %{items: [item | items]})
    end

    {:reply, true, state}
  end

  def handle_call({:get_todos, person}, _, state) do
    result = DB.find(person)

    {:reply, result, state}
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
