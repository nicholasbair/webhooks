defmodule WebhooksWeb.WebhookController do
  use WebhooksWeb, :controller
  require Logger

  def challenge(conn, params) do
    text(conn, params["challenge"])
  end

  def receive_webhook(conn, params) do
    transform_and_log(params)

    send_resp(conn, 200, "")
  end

  defp transform_and_log(params) do
    case ExNylas.WebhookNotifications.to_struct(params) do
      {:ok, struct} ->
        Logger.info(inspect(struct, pretty: true))
      {:error, message} ->
        Logger.error("Error transforming webhook params: #{inspect(message, pretty: true)}")
    end
  end
end
