use Mix.Config

config :cush_me,
  port: System.get_env("PORT") |> String.to_integer
