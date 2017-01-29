# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :leds_play,
  ecto_repos: [LedsPlay.Repo]

# Configures the endpoint
config :leds_play, LedsPlay.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "Lg48bwysMI5075mLj3A8M2b2sIiGPHAVAvdCTgzaJ55PIgzrtnnvw0bgSB2qkrMF",
  render_errors: [view: LedsPlay.ErrorView, accepts: ~w(html json)],
  pubsub: [name: LedsPlay.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
