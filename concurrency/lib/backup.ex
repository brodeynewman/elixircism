defmodule Todo.Backup do
  use GenServer

  @storage_dir "./backup"
  @storage_file "temp"

  def init(_) do
    File.mkdir_p(@storage_dir)
    {:ok, %{}}
  end

  def start() do
    GenServer.start(__MODULE__, nil, name: __MODULE__)
  end

  def path() do
    Path.join(@storage_dir, to_string(@storage_file))
  end

  def handle_call({:write, data}, _, state) do
    path()
    |> File.write!(:erlang.term_to_binary(data))

    {:noreply, state, state}
  end

  def handle_call({:read}, _, state) do
    location = path()

    data =
      case File.read(location) do
        {:ok, data} -> :erlang.binary_to_term(data)
        _ -> %{}
      end

    {:reply, data, state}
  end

  def write(data) do
    GenServer.call(__MODULE__, {:write, data})
  end

  def read do
    GenServer.call(__MODULE__, {:read})
  end
end
