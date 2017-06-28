use Mix.Config

config SlackCommand, port: System.get_env("PORT") |> String.to_integer
