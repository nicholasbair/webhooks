defmodule WebhooksWeb.WebhookUtil do
  @moduledoc """
  Functions to verify Nylas webhook notifications.
  """

  require Logger
  import Plug.Conn, except: [read_body: 2]

  def verify_webhook(%{method: "GET"} = conn, _opts), do: conn
  def verify_webhook(%{method: "POST"} = conn, _opts) do
    secret = Application.get_env(:webhooks, :nylas_webhook_secret)
    header = get_header(conn, "x-nylas-signature")
    body = conn.private.raw_body

    case ExNylas.WebhookNotifications.valid_signature(secret, body, header) do
      {:ok, true} ->
        conn

      {:ok, false} ->
        Logger.error("Invalid Nylas webhook signature")
        send_unauthorized(conn)

      {:error, message} ->
        Logger.error("Error verifying Nylas webhook signature: #{message}")
        send_unauthorized(conn)
    end
  end

  # Insert raw body into conn.private so that it can be accessed later for verification
  # Borrowed this approach from: https://github.com/virtualq/ex_twilio_webhook
  def read_body(conn, opts) do
    # Somewhat naive approach given read_body could return {:more, partial_body, conn}
    {:ok, body, conn} = Plug.Conn.read_body(conn, opts)

    conn =
      update_in(conn.private, fn private ->
        Map.put(private || %{}, :raw_body, body)
      end)

    {:ok, body, conn}
  end

  defp get_header(conn, key) do
    conn
    |> get_req_header(key)
    |> List.first()
  end

  defp send_unauthorized(conn) do
    conn
    |> send_resp(401, "Unauthorized")
    |> halt()
  end

end
