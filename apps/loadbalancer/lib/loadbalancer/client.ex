#TO-DO
# client asks for the issue. - DONE
# if it has no issue add to waitlist - DONE
# option to close the issue and close the session - DONE
# Add channels - DONE
# Add phoenix UI
# add more fields to the issue than title and desc - trivial
defmodule Loadbalancer.Client do
  use GenServer


  #############
  ##   API   ##
  #############

  def start_link(default \\ []) do
    GenServer.start_link(__MODULE__, default, name: @me)
  end
  def remote_server_call(pattern) do
    GenServer.call(Issuepool, pattern)
  end
  def request_work(pid) do
    GenServer.call(pid, {:request_work_handle})
  end
  def close_issue(pid) do
    GenServer.cast(pid, {:close_first_issue})
  end

  #========= MISC FUNCS API==========
  def show_state(pid) do
    GenServer.call(pid, {:show_state})
  end
  def stop(pid) do
    GenServer.call(pid, :stop)
  end
  ########################
  ##   Implementation   ##
  ########################
  def init() do
    { :ok, [] }
  end
  def handle_call({:request_work_handle}, _from, state) do
    issue = remote_server_call({:request_work})
    check_issue_validity(issue, state)
  end

  def handle_call({:show_state}, _from, state) do
    { :reply, state, state}
  end

  def handle_call(:stop, _from, status) do
    {:stop, :normal, status}
  end

  # Foll. fn logic from: https://gist.github.com/gabrielelana/59952df6adb5b9db9a4b
  def terminate(reason, _status) do
    IO.puts "Asked to stop because #{inspect reason}"
    :ok
  end
  #citaion ends

#casts
  def handle_cast({:issue_available, pid}, state) do
    {
      :noreply,
      List.insert_at(state, 0, remote_server_call({:request_work}))
    }
  end
  def handle_cast({:close_first_issue}, state) do
    {:noreply, List.delete_at(state, -1)}
  end


  #========= HELPER FUNCS

  def check_issue_validity(:empty, state) do
    { :reply, :empty, state}
  end
  def check_issue_validity(issue, state) do
    {
      :reply,
      issue,
      List.insert_at(state, 0, issue)
    }
  end


end
