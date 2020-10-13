defmodule Todo.Server do
  use GenServer

  alias Todo.Database, as: DB

  def start() do
    IO.puts("Starting server")

    DB.start()

    GenServer.start(__MODULE__, nil)
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

  def create(pid, person, item) do
    IO.inspect("fooo")
    GenServer.call(pid, {:create_todo, person, item})
  end
end
