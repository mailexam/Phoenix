defmodule Mailexam.TestEmail do
  import Swoosh.Email

  def deliver(to \\ "user@example.test", subject \\ "Phoenix + Mailexam", body \\ "Mailexam test from Phoenix") do
    from = System.get_env("MAIL_FROM") || "noreply@example.test"

    email =
      new()
      |> from(from)
      |> to(to)
      |> subject(subject)
      |> text_body(body)

    Mailexam.Mailer.deliver(email)
  end
end
