# Grafana of Rancher

## Add Prometheus Catlog



## Setting Grafana

### Templating

Query `container_memory_usage_bytes`

Regex `/instance=\"(.*?)\"/`

Legend `{{instance}} {{com_docker_compose_service}}` `{{io_rancher_stack_service_name}}`

### Memory Stats

Add Graph panel

`container_memory_usage_bytes`

#### Filter by Docker-compose

Query `container_memory_usage_bytes{instance=~"$node", com_docker_compose_project="tutormeetsdockers"}`

#### Filter by Rancher

`container_memory_usage_bytes{instance=~"$node", io_rancher_stack_name=~"tutor.*"}`



### CPU usage Stats

Add Graph panel 

`rate(container_cpu_user_seconds_total[5m])`

#### Filter by docker-compose

`{com_docker_compose_project=~"tutormeetsdockers"}`

Sumed by services

`sum(rate(container_cpu_usage_seconds_total{instance=~"$node", com_docker_compose_project=~"tutor.*"}[5m])) by (instance, com_docker_compose_service)`

#### Filter by Rancher service

`{io_rancher_stack_name=~"tutor.*"}`

Sumed by services

`sum(rate(container_cpu_usage_seconds_total{instance=~"$node", io_rancher_stack_name=~"tutor.*"}[5m])) by (instance, io_rancher_stack_service_name)`



### Network bandwidth

Sum by services with Transmit bytes `sum(rate(container_network_transmit_bytes_total{instance=~"$node", com_docker_compose_project="tutormeetsdockers"}[5m])) by (instance, com_docker_compose_service)`

`sum(rate(container_network_transmit_bytes_total{instance=~"$node", io_rancher_stack_name=~"tutor.*"}[5m])) by (instance, io_rancher_stack_service_name)`



Sum by services with Receive bytes `sum(rate(container_network_receive_bytes_total{instance=~"$node", com_docker_compose_project="tutormeetsdockers"}[5m])) by (instance, com_docker_compose_service)`

`sum( rate(container_network_receive_bytes_total{instance=~"$node", io_rancher_stack_name=~"tutor.*"}[5m]) ) by (instance, io_rancher_stack_service_name)`