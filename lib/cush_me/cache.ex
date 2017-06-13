defmodule CushMe.Cache do
  alias CushMe.Client

  def start_link do
    warm = fn ->
      case Client.fetch_images(cache: false) do
        {:ok, images} ->
          images
        {:error, _} ->
          IO.puts("Error loading initial image cache")

          []
      end
    end

    Agent.start_link(warm, name: __MODULE__)
  end

  def get() do
    Agent.get(__MODULE__, &(&1))
  end

  def put(images) do
    Agent.update(__MODULE__, fn(_) -> images end)
  end
end
