grafana

logQL

- {
  namespace="c418-team04-prod",
  app="orderbookapi"
  }|~ `(?i)heartbeat`

|~ `(?i)`: line contains pattern
|= `heartbeat` # (line contains)
!= `Heartbeat` # (line does not contain)
!~ `(?i)heartbeat` # (line does not contains pattern)

- count_over_time(
  {
    namespace="c418-team04-prod",
    app="orderbookapi"
  } |~ `(?i)heartbeat` [2m]
)

count_over_time function returns the number of log lines per time range ([2m] in this case)

- rate(
{
 namespace="c418-team04-prod",
 app="orderbookapi"
}|~ `(?i)heartbeat` [$__interval]
)

show the number of log entries per second per minute. 
Replace 1m with $__interval to use a dynamic time range optimized for fitting the graph.

- count_over_time(
{
 namespace="c418-team04-prod",
 app="orderbookapi"
}|~ `(?i)heartbeat` [2m]
)
/
count_over_time(
    {
        namespace="c418-team04-prod",
        app="orderbookapi"
    } [2m]
) * 100

percentage of logs per minute are heartbeat logs?

- {namespace="c418-team04-prod"} |= `"side": "buy"` | json | Price > 100 | OrderQty > 10

Parse the log entry by piping to json, then pipe it to the key Price. Only return logs where the price is greater than 100 and the order quantity is greater than 10.

- { app="ingress-nginx" } |~ `"host.*api.computerlab.online"`

We can use a regular expression to search for logs related to the API. The .* is called a greedy search. The dot will match any character, and the * will match any number of characters before the word API.

- {app="ingress-nginx"} |~ `"host.*api.computerlab.online"` |~ `"upstream_status": 2[0-9]{2}` |~ `"upstream_response_time": 0.0[0-9]{0,}`
 filter for requests that are faster than 0.1 seconds.

 


