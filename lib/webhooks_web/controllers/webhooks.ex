defmodule WebhooksWeb.WebhookController do
  use WebhooksWeb, :controller
  require Logger

  def challenge(conn, params) do
    text(conn, params["challenge"])
  end

  def receive_webhook(conn, params) do
    params
    |> ExNylas.WebhookNotifications.to_struct!()
    |> then(&Logger.info(inspect(&1, pretty: true)))

    send_resp(conn, 200, "")
  end
end
