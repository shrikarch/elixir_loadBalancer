Name: **Shrikar Chonkar**

------

**Hungry Consumer Model**

The issue-pool is handled by a constantly running GenServer with *transient* restart scheme. The client GenServers would log on and request for an issue to solve. If the Issuepool has an issue handy, it is sent to the client. If not, the client is added to the waitlist and will be sent an issue as soon as one is available.

------

#### Run Sequence
```elixir
p1 = LoadBalancer.ClientSupervisor.log_on
p2 = LoadBalancer.ClientSupervisor.log_on
#starts two clients
LoadBalancer.Issuepool.add_issue 'Title of the issue','Description of the issue'
#adds new issue into issuepool
LoadBalancer.Client.request_work p1
#p1 requests for work
```
At this point if there is no issue in the pool, the issuepool replies with ```:empty``` and adds the pid of that client to the list(state).

Both client and issuepool have ```show_state``` function to check the current issues they're holding.
```elixir
#for example:
LoadBalancer.Issuepool.show_state #and
LoadBalancer.Client.show_state p1
```
Once client is finished working on an issue, it can close and delete the issue by caling the ```close_issue(pid)``` function.
```elixir
LoadBalancer.Client.close_issue p1
```
All clients can be stopped using the ```stop(pid)``` function.
However, the issuepool is supposed to be permanently running.
```elixir
LoadBalancer.Client.stop p1
```
