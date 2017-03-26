 defmodule LoadbalancerTest do
  use ExUnit.Case
  doctest Loadbalancer

  describe "Stats on lists of ints" do
    setup do
       Loadbalancer.Issuepool.add_issue 'test title','test description'
    end

  test "Check if issue is added successfully" do
    assert Enum.count(Loadbalancer.Issuepool.show_state) == 2
  end

  test "flush sent data from issuepool" do
    prev_count = Enum.count(Loadbalancer.Issuepool.show_state)
    p1 = Loadbalancer.ClientSupervisor.log_on
    Loadbalancer.Client.request_work p1
    assert Enum.count(Loadbalancer.Issuepool.show_state) == prev_count - 1
  end

  test "receive data at the client" do
    p1 = Loadbalancer.ClientSupervisor.log_on
    Loadbalancer.Client.request_work p1
    assert Enum.count(Loadbalancer.Client.show_state p1) == 1
  end


end
end
