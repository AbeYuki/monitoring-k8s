# Grafana + MySQL + Loki + Promtail + InfluxDB + Telegraf + Promethus + Mimir + Alertmager + Node-exporter + Blackbox-exporter

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/AbeYuki/monitoring-k8s/tree/main.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/AbeYuki/monitoring-k8s/tree/testing)

![telegraf UI](./docs/ui-telegraf-resources.png)
![telegraf UI](./docs/ui-telegraf-network.png)
![loki UI](./docs/ui-loki.png)

# これは何？
kubernetes 環境をモニタリングするために、Grafana, Loki, Influxdb, Prometheus, Mimir 等をマニフェストにまとめたもの  

<br>

# 構成
- grafana
	- backend storage
		- mariadb
- prometheus
	- node-exporter
	- blackbox-exporter
	- remote_write
		- mimir
- alertmanager
- mimir
	- backend storage
		- minio
	- Monolithic mode
- loki
	- backend storage
		- minio
	- deployment modes
		- read,ruler
		- write
		- backend
	- promtail
- influxdb
	- telegraf
- minio-loki
- minio-mimir

<br>  
<br>  

# Quick start(minikube)
```
minikube start --cpus 3 --memory 5G
```
```
cd monitoring-k8s/overlay/testing/
```
```
kubectl apply -f namespace.yaml
```
```
kubectl apply -k secret/
```
```
kubectl apply -k ./
```
```
kubectl port-forward -n monitoring service/monitoring-frontend-grafana-app01-001 8080:80
```

http://127.0.0.1:8080/


