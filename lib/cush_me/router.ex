defmodule CushMe.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/" do
    conn = conn |> Plug.Conn.put_resp_content_type("application/json")
    text = conn.query_string
           |> Plug.Conn.Query.decode
           |> Map.get("text", "")

    resp =
      case CushMe.Client.get_image(text) do
        {:ok, image} ->
          %{
            response_type: "in_channel",
            text: URI.merge(CushMe.url(), image) |> to_string
          }
        {:error, message} ->
          %{
            response_type: "ephemeral",
            text: message
          }
      end

    send_resp(conn, 200, Poison.encode!(resp))
  end

  match _ do
    send_resp(conn, 404, Poison.encode!(%{error: "Not found"}))
  end
end
