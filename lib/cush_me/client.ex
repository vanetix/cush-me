defmodule CushMe.Client do
  alias HTTPoison.Response

  import Floki, only: [find: 2, attribute: 2]

  def get_images() do
    case HTTPoison.get(CushMe.url()) do
      {:ok, %Response{status_code: 200, body: body}} ->
        images =
          body
          |> find("#content a")
          |> attribute("href")
          |> Enum.map(fn(rel) ->
            URI.merge(CushMe.url(), rel) |> to_string
          end)

        {:ok, images}
      {:error, error} ->
        {:error, error}
    end
  end

  def get_image("") do
    with {:ok, images} <- get_images(), do: {:ok, Enum.random(images)}
  end

  def get_image("latest") do
    with {:ok, images} <- get_images(), do: {:ok, List.last(images)}
  end

  def get_image(match) when is_binary(match) do
    with {:ok, images} <- get_images() do
      image = images
              |> Enum.filter(fn(href) ->
                href
                |> String.replace(CushMe.url(), "")
                |> String.contains?(match)
              end)
              |> Enum.random

      {:ok, image}
    end
  end
end
