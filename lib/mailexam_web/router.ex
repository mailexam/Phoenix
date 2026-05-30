defmodule MailexamWeb.Router do
  use MailexamWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", MailexamWeb do
    pipe_through :api

    post "/mail/test", MailController, :create
  end

  if Application.compile_env(:mailexam, :dev_routes) do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
