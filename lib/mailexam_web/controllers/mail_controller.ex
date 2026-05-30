defmodule MailexamWeb.MailController do
  use MailexamWeb, :controller

  def create(conn, params) do
    to = params["to"] || "user@example.test"
    subject = params["subject"] || "Phoenix + Mailexam"
    body = params["body"] || params["text"] || "Mailexam test from Phoenix"

    case Mailexam.TestEmail.deliver(to, subject, body) do
      {:ok, _} ->
        json(conn, %{status: "ok"})

      {:error, reason} ->
        conn
        |> put_status(:internal_server_error)
        |> json(%{error: inspect(reason)})
    end
  end
end
