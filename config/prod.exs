use Mix.Config

config :slack_command, port: System.get_env("PORT") |> String.to_integer
