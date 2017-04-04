defmodule StaticPlug do
  use Application

  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    children = [
      # Define workers and child supervisors to be supervised
      Plug.Adapters.Cowboy.child_spec(:http, StaticPlug.UI, [], [port: 8000])
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StaticPlug.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

defmodule StaticPlug.UI do
  use Plug.Builder

  plug Plug.Static,
    at: "/static",
    from: :static_plug
  plug :not_found

  def not_found(conn, _) do
    send_resp(conn, 404, "not found")
  end
end
