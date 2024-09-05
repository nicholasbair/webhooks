# Webhooks

Simple web server for listening to Nylas webhooks.  Webhook payloads are transformed into [ExNylas](https://github.com/nicholasbair/ex_nylas) structs.

To start your server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`
  * Setup a tunnel so your server is accessible (e.g. use VS Code port forwarding)
  * Configure your Nylas webhook (`{your_server_url}/api/webhooks`)
  * Set the webhook secret as an environment variable `NYLAS_WEBHOOK_SECRET`
  * Restart the server for good measure

