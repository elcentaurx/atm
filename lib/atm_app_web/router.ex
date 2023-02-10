defmodule AtmAppWeb.Router do
  use Plug.ErrorHandler
  use AtmAppWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {AtmAppWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", AtmAppWeb do
    pipe_through :browser

    get "/", PageController, :index
  end


  # Other scopes may use custom stacks.
  scope "/api", AtmAppWeb do
    pipe_through :api

    get "/index", UserAtmController, :index
    get "/founds/:id", UserAtmController, :get_founds
    post "/create", UserAtmController, :create
    put "/update", UserAtmController, :update
    delete "/delete", UserAtmController, :delete

  end

  @impl Plug.ErrorHandler
  def handle_errors(conn, %{kind: _kind, reason: _reason, stack: _stack}) do
    if(conn.status >= 500) do
      render_json(%{"error" => "It seems that we have problems, we are working to solve it"}, conn, conn.status)
    end
    render_json(%{"error" => "We couldn't find what you were looking for or you don't have permission to see it."}, conn, conn.status)
  end

  def render_json(response, conn, status) do
    json put_status(conn, status), response
  end

  # Enables LiveDashboard only for development
  #
  # If you want to use the LiveDashboard in production, you should put
  # it behind authentication and allow only admins to access it.
  # If your application does not have an admins-only section yet,
  # you can use Plug.BasicAuth to set up some basic authentication
  # as long as you are also using SSL (which you should anyway).
  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: AtmAppWeb.Telemetry
    end
  end

  # Enables the Swoosh mailbox preview in development.
  #
  # Note that preview only shows emails that were sent by the same
  # node running the Phoenix server.
  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through :browser

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
