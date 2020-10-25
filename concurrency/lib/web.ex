defmodule Todo.Web do
  use Plug.Router

  plug :match
  plug :dispatch

  def child_spec(_arg) do
    IO.puts("Starting web server")

    Plug.Adapters.Cowboy.child_spec(
      scheme: :http,
      options: [port: 5454],
      plug: __MODULE__
    )
  end

  post "/entries" do
    conn = Plug.Conn.fetch_query_params(conn)
    list_name = Map.fetch!(conn.params, "list")
    title = Map.fetch!(conn.params, "title")

    list_name
    |> Todo.Cache.start_process()
    |> Todo.Server.create(list_name, title)

    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, "OK")
  end

  get "/entries" do
    conn = Plug.Conn.fetch_query_params(conn)
    list_name = Map.fetch!(conn.params, "list")

    pid =
      list_name
      |> Todo.Cache.start_process()

    entries =
      case Todo.Server.get(pid, list_name) do
        [] -> []
        [{_, %{items: items}}] -> %{items: items}
      end

    conn
    |> Plug.Conn.put_resp_content_type("text/plain")
    |> Plug.Conn.send_resp(200, entries)
  end
end
