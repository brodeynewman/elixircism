defmodule Todo.Server do
  use GenServer

  alias Todo.Database, as: DB

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def init(_) do
    {:ok, pid} = DB.start()

    {:ok, %{database: pid}}
  end

  def handle_call({:create_todo, person, item}, _, %{database: db} = state) do
    # fetch previous record
    case DB.find(db, person) do
      [] ->
        DB.insert(db, person, %{ items: [item] })
      [{_key, %{items: items}}] ->
        DB.insert(db, person, %{ items: [item | items] })
    end

    {:reply, true, state}
  end

  def handle_call({:get_todos, person}, _, %{database: db} = state) do
    result = DB.find(db, person)

    {:reply, result, state}
  end

  def get(pid, person) do
    GenServer.call(pid, {:get_todos, person})
  end

  def create(pid, person, item) do
    GenServer.call(pid, {:create_todo, person, item})
  end
end
