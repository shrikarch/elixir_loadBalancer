#TO-DO
# if client requests issue and none are available, add them to wait queue - DONE
# add more tests
# State prevention if the issuepool goes down
defmodule Loadbalancer.Issuepool do
  use GenServer

  @isp Issuepool


  #############
  ##   API   ##
  #############
  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: @isp)
  end

  def add_issue(title, desc) do
    GenServer.cast(@isp, {:add_issue, title, desc})
  end

  def client_server_call(pattern, process) do
    GenServer.cast(process, {pattern, process})
  end


  #========= MISC FUNCS API==========
  def show_state() do
    GenServer.call(@isp, {:show_state})
  end

  ########################
  ##   Implementation   ##
  ########################
  def init(args) do
    { :ok, [[]] }
  end

  def handle_call({:show_state}, _from, state) do
    { :reply, state, state}
  end

  def handle_call({:request_work}, {pid, ref}, [nodes | issues]) do
    return = fn
      ([nodes | []]) ->
      GenServer.cast(@isp, {:add_to_waitlist, pid})
      {
        :reply,
        :empty,
        [nodes | issues]
      }
      ([nodes | issues]) ->
      {
        :reply,
        List.last(issues),
        [nodes | List.delete_at(issues, -1)]
      }
    end
    return.([nodes | issues])
  end

  def handle_cast({:add_issue, title, desc}, [nodes | issues]) do
    check_waitlist(title, desc, [nodes | issues], Enum.empty?(nodes))
  end

  def handle_cast({:add_to_waitlist, pid}, [nodes | issues]) do
    {
      :noreply,
      [List.insert_at(nodes, 0, pid) | issues]
     }
  end

  #========= HELPER FUNCS

  def check_waitlist(title, desc, [nodes | issues], false) do
    issues = List.insert_at(issues, 0, %{title: title, desc: desc})
    client_server_call(:issue_available, List.last(nodes))
    {
      :noreply,
      [List.delete_at(nodes, -1) | issues]
     }
  end
  def check_waitlist(title, desc, [nodes | issues], true) do
    {
      :noreply,
      [nodes | List.insert_at(issues, 0, %{title: title, desc: desc})]
     }
  end



end
