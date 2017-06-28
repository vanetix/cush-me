defmodule CushMe do
  def url(), do: Application.get_env(:cush_me, :url)
end
