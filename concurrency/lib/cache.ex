defmodule Todo.Cache do
  alias Todo.Backup

  def init(_) do
    {:ok, _} = Backup.start_link()
    initial_state = Backup.read()

    Process.flag(:trap_exit, true)
    {:ok, initial_state}
  end

  def start_link() do
    IO.puts("Starting todo-cache")

    DynamicSupervisor.start_link(name: __MODULE__, strategy: :one_for_one)
  end

  def handle_call({:exit}, _, _) do
    exit(:shutdown)
  end

  defp start_child(name) do
    DynamicSupervisor.start_child(__MODULE__, {Todo.Server, name})
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      type: :supervisor
    }
  end

  def quit(pid) do
    GenServer.call(pid, {:exit})
  end

  def terminate(_reason, state) do
    Backup.write(state)
  end

  def start_process(name) do
    case start_child(name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} ->
        IO.puts("Server process already started. Reusing pid.")

        pid
    end
  end
end
