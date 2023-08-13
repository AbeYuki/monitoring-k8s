# Grafana + MySQL + Loki + Promtail + InfluxDB + Telegraf + Promethus + Alertmager + Node-exporter + Procces-exporter + Blackbox-exporter

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/AbeYuki/monitoring-k8s/tree/main.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/AbeYuki/monitoring-k8s/tree/testing)
![Argocd](https://argocd.aimhighergg.com/api/badge?name=monitoring-k8s&revision=true)

![telegraf UI](./docs/ui-telegraf-resources.png)
![telegraf UI](./docs/ui-telegraf-network.png)
![loki UI](./docs/ui-loki.png)

# 目次

* [Description](#description)
* [Quick start(minikube)](#quick-startminikube)
* [Configure](#configure)
* [Deploy](#deploy)
* [Grafana datasource settings](#grafana-datasource-settings)

# Description
- Grafana settings stored in MySQL
- Loki logs are stored on the local file system
- Prometheus data stored in InfluxDB2 with telegraf plugin
- Each exporter monitors nodes, processes, containers, networks and services.
- Telegraf is responsible for monitoring nodes, containers, networks and persisting prometheus metrics

<br>  
<br>  

# Quick start(minikube)

```
cd monitoring-k8s/overlay/minikube/
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
minikube tunnel
```

http://127.0.0.1  

[Grafana datasource stting](#grafana-datasource-settings)  

<br>  
<br>  

# Configure

```
.
├── README.md
├── base
│   ├── alertmanager
│   │   └── deployment-backend-alertmanager01.yaml
│   ├── blackbox-exporter
│   │   └── deployment-backend-blackbox-exporter01.yaml
│   ├── grafana
│   │   ├── deployment-backend-grafana-db01.yaml
│   │   └── deployment-frontend-grafana-app01.yaml
│   ├── influxdb
│   │   └── deployment-backend-influxdb-db01.yaml
│   ├── kustomization.yaml
│   ├── loki
│   │   └── deployment-frontend-loki-app01.yaml
│   ├── node-exporter
│   │   └── daemonset-backend-node-exporter-agent01.yaml
│   ├── process-exporter
│   │   └── daemonset-backend-process-exporter01.yaml
│   ├── prometheus
│   │   └── deployment-backend-prometheus-app01.yaml
│   ├── promtail
│   │   └── daemonset-backend-agent01.yaml
│   ├── rbac
│   │   ├── rbac-influxdb.yaml
│   │   ├── rbac-prometheus.yaml
│   │   ├── rbac-promtail.yaml
│   │   └── rbac-telegraf.yaml
│   └── telegraf
│       └── daemonset-backend-agent01.yaml
└── overlay
    ├── microk8s
    │   ├── config-alertmanager.yaml
    │   ├── config-blackbox-exporter.yaml
    │   ├── config-loki.yaml
    │   ├── config-process-exporter.yaml
    │   ├── config-prometheus.yaml
    │   ├── config-promtail.yaml
    │   ├── grafana.ini
    │   ├── kustomization.yaml
    │   ├── namespace.yaml
    │   ├── rules-loki.yaml
    │   ├── rules-prometheus.yaml
    │   ├── secret
    │   │   ├── config-alertmanager.yaml
    │   │   ├── kustomization.yaml
    │   │   ├── password.txt
    │   │   ├── token-slack.txt
    │   │   └── token-telegraf.txt
    │   ├── telegraf.conf
    │   ├── transformer-label.yaml
    │   └── transformer-suffixprefix.yaml
    ├── minikube
    │   ├── config-alertmanager.yaml
    │   ├── config-blackbox-exporter.yaml
    │   ├── config-loki.yaml
    │   ├── config-process-exporter.yaml
    │   ├── config-prometheus.yaml
    │   ├── config-promtail.yaml
    │   ├── grafana.ini
    │   ├── kustomization.yaml
    │   ├── namespace.yaml
    │   ├── rules-loki.yaml
    │   ├── rules-prometheus.yaml
    │   ├── secret
    │   │   ├── config-alertmanager.yaml
    │   │   ├── kustomization.yaml
    │   │   ├── password.txt
    │   │   ├── token-slack.txt
    │   │   └── token-telegraf.txt
    │   ├── telegraf.conf
    │   ├── transformer-label.yaml
    │   └── transformer-suffixprefix.yaml
    ├── prod
    │   ├── config-alertmanager.yaml
    │   ├── config-blackbox-exporter.yaml
    │   ├── config-loki.yaml
    │   ├── config-process-exporter.yaml
    │   ├── config-prometheus.yaml
    │   ├── config-promtail.yaml
    │   ├── grafana.ini
    │   ├── kustomization.yaml
    │   ├── namespace.yaml
    │   ├── rules-loki.yaml
    │   ├── rules-prometheus.yaml
    │   ├── secret
    │   │   ├── kustomization.yaml
    │   │   ├── password.txt
    │   │   ├── token-slack.txt
    │   │   └── token-telegraf.txt
    │   ├── telegraf.conf
    │   ├── transformer-label.yaml
    │   └── transformer-suffixprefix.yaml
    ├── staging
    │   ├── config-alertmanager.yaml
    │   ├── config-blackbox-exporter.yaml
    │   ├── config-loki.yaml
    │   ├── config-process-exporter.yaml
    │   ├── config-prometheus.yaml
    │   ├── config-promtail.yaml
    │   ├── grafana.ini
    │   ├── kustomization.yaml
    │   ├── namespace.yaml
    │   ├── rules-loki.yaml
    │   ├── rules-prometheus.yaml
    │   ├── secret
    │   │   └── kustomization.yaml
    │   ├── telegraf.conf
    │   ├── transformer-label.yaml
    │   └── transformer-suffixprefix.yaml
    └── testing
        ├── config-alertmanager.yaml
        ├── config-blackbox-exporter.yaml
        ├── config-loki.yaml
        ├── config-process-exporter.yaml
        ├── config-prometheus.yaml
        ├── config-promtail.yaml
        ├── grafana.ini
        ├── kustomization.yaml
        ├── namespace.yaml
        ├── rules-loki.yaml
        ├── rules-prometheus.yaml
        ├── secret
        │   └── kustomization.yaml
        ├── telegraf.conf
        ├── transformer-label.yaml
        └── transformer-suffixprefix.yaml
```

<br>

## secret setup

```
cd overlay/testing/
```
DB などで使うパスワード
```
echo -n 'password' > secret/password.txt
```
Influxdb のトークン
```
echo -n 'token' > secret/token-telegraf.txt
```
slack のトークン  
```
echo -n 'https://hooks.slack.com/services/****/****/********' > secret/token-slack.txt
```

<br>  

## rules configure
環境に合わせて alert rule の config 設定  

```
vi rules-prometheus.yaml
```
```
vi rules-loki.yaml
```

<br>

## kustomization.yaml の patchesStrategicMerge を修正して storageclass,resources の調整
```yaml
patchesStrategicMerge:
- |-
  apiVersion: v1
  kind: PersistentVolumeClaim
  metadata:
    name: frontend-grafana-app01
  spec:
    accessModes:
      - ReadWriteMany
    resources:
      requests:
        storage: <MODIFY>
    storageClassName: <MODIFY>
- |-
  apiVersion: apps/v1
  kind: Deployment
  metadata:
    name: frontend-grafana-app01
  spec:
    template:
      spec:
        containers:
        - name: frontend-grafana-app01
          image: frontend-grafana-app01
          imagePullPolicy: IfNotPresent
          resources:
            requests:
              cpu: <MODIFY>
              memory: <MODIFY>
            limits:
              cpu: <MODIFY>
              memory: <MODIFY>
```

<br>  
<br>  

## docker.sock の権限変更
docker metrics を収集する場合、 docker.sock の権限を 666 に変更する
```
sudo chmod 666 /var/run/docker.sock
```

<br>
<br>


# Deploy

## deploy namespace
```
kubectl apply -f namespace.yaml
```

## deploy secret
```
kubectl apply -k secret/
```

## deploy resource
```
kubectl apply -k ./
```

<br>
<br>

# Grafana datasource settings

## Influxdb settings
- Query Language
  - Flux
- url
  - minikube
    - http://monitoring-backend-influxdb-db01-001:8086
  - testing
    - http://testing-monitoring-backend-influxdb-db01-001:8086
  - prod
    - http://monitoring-backend-influxdb-db01-001:8086
- Access
  - Server(default)
- InfluxDB Details(example settings)
  - Organization
    - monitoring
  - Token
    - token
  - Default Bucket
    - monitoring
- InfluxDB Details(minikube)
  - Organization
    - monitoring
  - Token
    - minikube
  - Default Bucket
    - monitoring

![datasource-influxdb](./docs/datasource-influxdb.png)

<br>

## Loki settings

- HTTP
  - URL
    - minikube
      - http://monitoring-frontend-loki-app01-001:3100
    - testing
      - http://testing-monitoring-frontend-loki-app01-001:3100
    - prod
      - http://monitoring-frontend-loki-app01-001:3100 

![datasource-influxdb](./docs/datasource-loki.png)


## prometheus settings

- HTTP
  - URL
    - minikube
      - http://monitoring-backend-prometheus-db01-001:9090
    - testing
      - http://testing-monitoring-backend-prometheus-db01-001:9090
    - prod
      - http://monitoring-backend-prometheus-db01-001:9090

## grafana.com から Dashboard を import

https://grafana.com/orgs/aim4highergg/dashboards

[Loki:AccessLogs](https://grafana.com/grafana/dashboards/16226)  
[Loki:NamespaceLogs](https://grafana.com/grafana/dashboards/16227)  
[Loki:SystemLogs](https://grafana.com/grafana/dashboards/16228)  
[Telegraf:KubernetesResources](https://grafana.com/grafana/dashboards/16229)  
[Telegraf:SystemResources](https://grafana.com/grafana/dashboards/16230)  

### Dashboard ID を import

![Grafana_dashboard1](./docs/import-dashboard1.png)  
![Grafana_dashboard2](./docs/import-dashboard2.png)  
![Grafana_dashboard3](./docs/import-dashboard3.png)  
![Grafana_dashboard4](./docs/import-dashboard4.png)  