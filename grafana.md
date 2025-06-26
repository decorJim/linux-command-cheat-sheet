grafana

###################### logQL ###########################

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

- { namespace="c418-team04-prod", app="orderbookapi" } |= `"side": "buy"` | json | Price > 100 

Parse the log entry by piping to json, then pipe it to the key Price. Only return logs where the price is greater than 100.

- { app="ingress-nginx" } |~ `"host.*api.computerlab.online"`

We can use a regular expression to search for logs related to the API. The .* is called a greedy search. The dot will match any character, and the * will match any number of characters before the word API.

- {app="ingress-nginx"} |~ `"host.*api.computerlab.online"` |~ `"upstream_status": 2[0-9]{2}`
Fetch all log lines matching label filters. Return log lines that match a RE2 regex pattern. "host.*api.computerlab.online". Return log lines that match a RE2 regex pattern. "upstream_status": 2[0-9]{2}.

- {app="ingress-nginx"} |~ `"host.*api.computerlab.online"` |~ `"upstream_status": 2[0-9]{2}` |~ `"upstream_response_time": 0.0[0-9]{0,}`
 filter for requests that are faster than 0.1 seconds.

############################### Prometheus ##############################

- http_requests_total{
  handler="/stock_quote",
  method="GET",status="2xx" ,
  namespace="c418-team04-prod"
}
Fetch all series matching metric name and label filters.

- sum(http_requests_total{ # number of 4xx request
  handler="/stock_quote",
  namespace="c418-team04-prod",
  method="GET",
  status="2xx"
})
/  # divide by
sum(http_requests_total{ # total number of request
  handler="/stock_quote",
  namespace="c418-team04-prod",
  method="GET",
  status!="4xx"
}) * 100

percentage of stock quote working

- sum(rate(nginx_ingress_controller_requests{exported_namespace="c418-team04-prod",ingress="orderbook",status=~"(2|3).*",exported_service="orderbookfe"}[1w]))
/
sum(rate(nginx_ingress_controller_requests{exported_namespace="c418-team04-prod",ingress="orderbook", status!~"4.*",exported_service="orderbookfe"}[1w]))
* 100

for a week percentage of successful request in orderbookfe



####################### Prometheus FastAPI Instrumentor ###########3#####

 - sum(rate(nginx_ingress_controller_requests{exported_namespace="c418-team04-prod",ingress="orderbook",status=~"(2|3).*",exported_service="orderbookfe"}[1h]))
/
sum(rate(nginx_ingress_controller_requests{exported_namespace="c418-team04-prod",ingress="orderbook", status!~"4.*",exported_service="orderbookfe"}[1h]))
* 100

Consider the code below that uses metrics from NGINX to monitor the Front End (not the API) to calculate the percentage of 2xx or 3xx requests / all non 4xx requests per hour.


- sum(rate(nginx_ingress_controller_response_duration_seconds_bucket{exported_namespace="c418-team04-prod",ingress="orderbook",le="0.01",exported_service="orderbookfe"}[1h]))
/
sum(rate(nginx_ingress_controller_response_duration_seconds_bucket{exported_namespace="c418-team04-prod",ingress="orderbook", le="+Inf",exported_service="orderbookfe"}[1h]))
* 100

We can use the ingress-controller to calculate latency as well

- rate(
    container_memory_working_set_bytes {
        namespace="c418-team04-prod",
        container="orderbookapi"
    } [2m]
)

Prometheus also obtains metrics from the Kubernetes cluster, such as statistics on your container's memory.

- rate(
    container_cpu_usage_seconds_total{
        namespace="c418-team04-prod",
        container="orderbookapi"
    } [2m]
)

CPU usage of your containers

- kube_deployment_status_replicas_available{
    namespace="c418-team04-prod",
    deployment="orderbookdb"
}

displays the number of replicas for the database deployment

- mysql_up{
    namespace="c418-team04-prod"
}

check if the database is up

- rate(
  http_request_duration_seconds_bucket{ 
    handler!~"(none|/metrics)",
    le="0.5",
    namespace="c418-c418-team04-prod"
  }[2m])

  It is the rate of request with latency less than or equal to (le) 0.5 seconds

- sum(                                                    # Number of all requests faster than 0.5 seconds
    rate(
        http_request_duration_seconds_bucket{
            handler!~"(none|/metrics)",
            le="0.5",
            namespace="c418-team04-prod"
        }
    )
)
 / 
sum                                                       # all requests
  (rate(
    http_request_duration_seconds_bucket{
      handler!~"(none|/metrics)",
      le="+Inf",# infinity, or all request
      namespace="c418-team04-prod"
    } [2m])
  )

- sum by (handler)
  (rate(
    http_request_duration_seconds_bucket{
      handler!~"(none|/metrics)",
      le="0.5",
      namespace="c418-team04-prod"
    }[$__rate_interval])
  )
  /
sum by (handler)
  (rate(
    http_request_duration_seconds_bucket{
      handler!~"(none|/metrics)",
      le="+Inf",
      namespace="c418-team04-prod"
      }[$__rate_interval])
  )

group all series with the same handler and sum those

- sum by (handler) (
  rate(http_request_duration_seconds_bucket{
    handler="/stock_quote",
    le="0.5",
    namespace="c418-team04-prod"
  }[$__rate_interval])
)
/
sum by (handler) (
  rate(http_request_duration_seconds_bucket{
    handler="/stock_quote",
    le="+Inf",
    namespace="c418-team04-prod"
  }[$__rate_interval])
)

Filter for only stock_quote

- histogram_quantile(0.95, sum by (le) (rate(http_request_duration_seconds_bucket{namespace="c418-team01-prod"}[5m])))

######################## SLI #############################
- sum(                                        # add result of all pods duplicate or restart to not impact result
    rate(                                     # for the whole there was an increase of 6000 requests that fits these criteria
                                              # what is the average per second 6000/ 1 week in seconds                
      http_request_duration_seconds_bucket{   # total request of /exchange_rate that was faster than 0.5s latency ever since pod started
        namespace="c418-team04-prod",         
        handler="/exchange_rate",             
        le="0.5"
      } [1w]
    
    )
  )
  /
  sum(
    rate(
      http_request_duration_seconds_count{
        namespace="c418-team04-prod",
        handler="/exchange_rate"
      }[1w]
    )
  ) * 100

-   sum(
      rate(
        http_requests_total{
          namespace="c418-team04-prod",
          handler="/trade",
          status=~"2.."
        } [1w]
      )
    )
    /
    sum(
      rate(
        http_requests_total{
          namespace="c418-team04-prod",
          handler="/trade",
          status!="4.."                       # all request not coded 4xx aka 2xx, 5xx etc
        } [1w]
      )
    ) * 100




avg (                                     # the average cpu time usage across all containers
  rate(                                   # for the last 5 min window the average time of cpu usage in second per container
    container_cpu_usage_seconds_total {   # the total usage of cpu per container in seconds of all time
      namespace="c418-team04-prod",       # only include those in the namespace 
      container!=""                       # not include container responsible for pod lifecycle or networking
    } [5m]
  )
)




count_over_time                              # apply that function for all 5 min within 1 day count only those less than 
                                             # 0.65                  
(
  (
    avg(                                     # the average of all containers within that last 5 min                         
      rate(                                  # for the last 5 min if it went from 10000s to 12000s total increase 
                                             # of 2000s we take this divided by 5m in seconds per container                      
        container_cpu_usage_seconds_total{   # the toal cpu usage time ever since each container started 
          namespace="c418-team04-prod", 
          container!=""
        } [5m]                                
      )
    ) < 0.65                                  
  ) [1d:5m]                                   
)
/
(
  count_over_time(                            
    avg(
      rate(
        container_cpu_usage_seconds_total{
          namespace="c418-team04-prod", 
          container!=""
        } [5m]
      )
    ) [1d:5m]
  )
)
* 100




count_over_time(                             # the number of 5 min interval where the proportion of used memory is less than 0.85
  (  
    avg(                                     # average of used memory across containers
      container_memory_working_set_bytes{    # memory in bytes actively used per container in the last second
        namespace="c418-team04-prod",
        container!=""
      }
    )/
    avg(
      cluster_autoscaler_cluster_memory_current_bytes  # total memory available in the cluster in bytes 
    ) < 0.85      
  ) [1d:5m]
)
/
count_over_time(                             # all the 5 min window of that day
  (  
    avg(        
      container_memory_working_set_bytes{
        namespace="c418-team04-prod",
        container!=""
      }
    )/
    avg(
      cluster_autoscaler_cluster_memory_current_bytes
    )
  ) [1d:5m]
) * 100
  








