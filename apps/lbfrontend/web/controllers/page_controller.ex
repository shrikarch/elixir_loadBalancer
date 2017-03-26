defmodule Lbfrontend.PageController do
  use Lbfrontend.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
