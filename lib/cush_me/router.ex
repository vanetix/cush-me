defmodule CushMe.Router do
  use Plug.Router

  plug Plug.Logger
  plug :match
  plug :dispatch

  get "/" do
    text = conn.query_string
           |> Plug.Conn.Query.decode
           |> Map.get("text", "")

    case CushMe.Client.get_image(text) do
      {:ok, image} ->
        resp = %{
          response_type: "in_channel",
          text: image
        }

        send_resp(conn, 200, Poison.encode!(resp))
      {:error, message} ->
        resp = %{
          response_type: "ephemeral",
          text: message
        }

        send_resp(conn, 500, Poison.encode!(resp))
    end
  end

  match _ do
    send_resp(conn, 404, Poison.encode!(%{error: "Not found"}))
  end
end
