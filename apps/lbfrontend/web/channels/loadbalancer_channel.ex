defmodule Lbfrontend.LoadbalancerChannel do
  use Lbfrontend.Web, :channel

  def join("loadbalancer:game", _payload, socket) do
    {:ok, assign(socket, :game, Loadbalancer.ClientSupervisor.log_on) }
  end

end
