defmodule WebhooksWeb.WebhookController do
  use WebhooksWeb, :controller

  def challenge(conn, params) do
    text(conn, params["challenge"])
  end

  def receive_webhook(conn, _params) do
    send_resp(conn, 200, "")
  end
end
