defmodule CushMe.Router do
  use SlackCommand.Router

  command text do
    CushMe.Client.get_image(text)
  end
end
