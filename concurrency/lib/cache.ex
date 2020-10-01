defmodule Todo.Cache do
  use GenServer

  alias Todo.Server
  alias Todo.Backup

  def init(_) do
    {:ok, _} = Backup.start()
    initial_state = Backup.read()

    Process.flag(:trap_exit, true)
    {:ok, initial_state}
  end

  def start do
    GenServer.start(__MODULE__, nil)
  end

  def handle_call({:server_process, name}, _, state) do
    case Map.fetch(state, name) do
      {:ok, ticketed} ->
        {:reply, ticketed, state}
      :error ->
        {:ok, server} = Server.start()

        {:reply, server, Map.put(state, name, server)}
    end
  end

  def handle_call({:exit}, _, _) do
    exit(:shutdown)
  end

  def quit(pid) do
    GenServer.call(pid, {:exit})
  end

  def terminate(_reason, state) do
    Backup.write(state)
  end

  def start_process(pid, name) do
    GenServer.call(pid, {:server_process, name})
  end
end
