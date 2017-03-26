defmodule Loadbalancer.ClientSupervisor do
  use Supervisor
  @sup ServerProcess

  def start_link(opts \\ []) do
    Supervisor.start_link(__MODULE__, :ok, name: @sup)
  end

  def log_on do
    {:ok, pid} = Supervisor.start_child(@sup, [])
    pid
  end

  def init(:ok) do
    import Supervisor.Spec, warn: false
    # pool_options = [
    #   name: {:local, :hangman_pool},
    #   worker_module: Hangman.GameServer,
    #   size: 2,
    #   max_overflow: 4
    # ]
    children = [
      #:poolboy.child_spec(:hangman_pool, pool_options, [])
      worker(Loadbalancer.Client, [], restart: :temporary)
    ]

    supervise(children, strategy: :simple_one_for_one)
  end
end
