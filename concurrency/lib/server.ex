defmodule Ticketing.Server do
  use GenServer

  alias Ticketing.Database, as: DB

  def start() do
    GenServer.start(__MODULE__, nil)
  end

  def init(_) do
    {:ok, pid} = DB.start()

    {:ok, %{database: pid}}
  end

  def handle_call({:create_ticket, person, price}, _, %{database: db} = state) do
    true = DB.insert(db, person, price)

    {:reply, true, state}
  end

  def handle_call({:get_tickets, person}, _, %{database: db} = state) do
    result = DB.find(db, person)

    {:reply, result, state}
  end

  def get_tickets(pid, person) do
    GenServer.call(pid, {:get_tickets, person})
  end

  def create_ticket(pid, person, price) do
    GenServer.call(pid, {:create_ticket, person, price})
  end
end
