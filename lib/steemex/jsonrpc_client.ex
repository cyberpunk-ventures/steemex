defmodule Steemex.SteemitApiClient do
  alias JSONRPC2.Clients.HTTP

  @url Application.get_env(:steemex, :api_url)

  def call([api, method, args]) do
    api = case api do
      "database_api" -> "condenser_api"
      _ -> throw("This JSONRPC api is not supported")
    end
    response = HTTP.call(@url, "#{api}.#{method}", args)
    {:ok, response}
  end

end
