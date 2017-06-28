defmodule CushMe.Client do
  alias CushMe.Cache
  alias HTTPoison.Response

  import Floki, only: [find: 2, attribute: 2]

  def get_images() do
    Task.start(__MODULE__, :fetch_images, [])

    Cache.get()
  end

  def get_image("") do
    {:ok, get_images() |> Enum.random() |> build_url()}
  end

  def get_image("latest") do
    with {:ok, [image | _]} <- fetch_images(), do: {:ok, image |> build_url()}
  end

  def get_image(match) do
    case get_images() |> Enum.filter(&String.contains?(&1, match)) do
      [] ->
        {:error, "There doesn't seem to be a Cush for that occasion."}
      list ->
        {:ok, list |> Enum.random() |> build_url()}
    end
  end

  def fetch_images(opts \\ []) do
    case HTTPoison.get(CushMe.url()) do
      {:ok, %Response{status_code: 200, body: body}} ->
        images =
          body
          |> find("#content a")
          |> attribute("href")

        if Keyword.get(opts, :cache, true) do
          Cache.put(images)
        end

        {:ok, images}
      {:error, error} ->
        {:error, error}
      _ ->
        {:error, "Invalid status code received"}
    end
  end

  defp build_url(image), do: URI.merge(CushMe.url(), image) |> to_string
end
