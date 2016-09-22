# Grafana of Rancher

## Add Prometheus Catlog



## Setting Grafana

### Templating

Query `container_memory_usage_bytes`

Regex `/instance=\"(.*?)\"/`



### Memory Stats

Add Graph panel

`container_memory_usage_bytes`

#### Filter by Docker-compose

Query `{instance=~"$node", com_docker_compose_project="tutormeetsdockers"}`

#### Filter by Rancher

`{io_rancher_stack_name=~"Tutor.*"}`



### CPU usage Stats (TODO)

Add Graph panel 

`rate(container_cpu_user_seconds_total[5m])`

#### Filter by docker-compose

`{com_docker_compose_project=~"tutormeetsdockers"}`

#### Filter by Rancher service

`{io_rancher_stack_name=~"Tutor.*"}`

Sumed by services

`sum(rate(container_cpu_usage_seconds_total{instance=~"$node", io_rancher_stack_name=~"Tutor.*"}[5m])) by (instance, io_rancher_stack_service_name)`



### Network bandwidth

Sum by services `sum(container_network_transmit_bytes_total{instance=~"$node", com_docker_compose_project="tutormeetsdockers"}) by (com_docker_compose_service)`