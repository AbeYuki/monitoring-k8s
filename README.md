# Grafana + MySQL + Loki + Promtail + InfluxDB + Telegraf + Promethus + Node-exporter + Alertmager
[![CircleCI](https://dl.circleci.com/status-badge/img/gh/AbeYuki/monitoring-k8s/tree/main.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/AbeYuki/monitoring-k8s/tree/testing)
![Argocd](https://argocd.aimhighergg.com/api/badge?name=monitoring-k8s&revision=true)

![telegraf UI](./docs/ui-telegraf-resources.png)
![telegraf UI](./docs/ui-telegraf-network.png)
![loki UI](./docs/ui-loki.png)


# 目次

* [Quick start(minikube)](#quick-startminikube)
* [Configure](#configure)
* [Deploy](#deploy)
* [Grafana datasource settings](#grafana-datasource-settings)

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

[Grafana datasource stting](#grafana-datasource-setting)  

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
    │   │   └── token-telegraf.txt
    │   ├── telegraf.conf
    │   ├── transformer-label.yaml
    │   └── transformer-suffixprefix.yaml
    ├── minikube
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
    │   │   └── token-telegraf.txt
    │   ├── telegraf.conf
    │   ├── transformer-label.yaml
    │   └── transformer-suffixprefix.yaml
    ├── prod
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
    │   │   └── token-telegraf.txt
    │   ├── telegraf.conf
    │   ├── transformer-label.yaml
    │   └── transformer-suffixprefix.yaml
    ├── staging
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
    │   │   └── token-telegraf.txt
    │   ├── telegraf.conf
    │   ├── transformer-label.yaml
    │   └── transformer-suffixprefix.yaml
    └── testing
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
        │   ├── config-alertmanager.yaml
        │   ├── kustomization.yaml
        │   ├── password.txt
        │   └── token-telegraf.txt
        ├── telegraf.conf
        ├── transformer-label.yaml
        └── transformer-suffixprefix.yaml
```

<br>

## secret setup

'''
cd overlay/testing/
'''
```
echo -n 'password' > secret/password.txt
```
```
echo -n 'token' > secret/token-telegraf.txt
```
slack_api_url と slack_configs の channel を記載
```
cat <<'EOF'> secret/config-alertmanager.yaml
global:
  slack_api_url: 'https://hooks.slack.com/services/****/****/********'
route:
  receiver: 'slack'
receivers:
  - name: 'slack'
    slack_configs:
    - channel: '#channel-name'
EOF
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
```
vagrant@ubuntu2004:~$ ls -l /var/run/docker.sock
srw-rw---- 1 root docker 0 May  9 05:29 /var/run/docker.sock
vagrant@ubuntu2004:~$ sudo chmod 666 /var/run/docker.sock
vagrant@ubuntu2004:~$ ls -l /var/run/docker.sock
srw-rw-rw- 1 root docker 0 May  9 05:29 /var/run/docker.sock
vagrant@ubuntu2004:~$ 
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
※ namespace が異なる datasource を参照する場合は FQDN を設定
```
http://monitoring-frontend-loki-app01-001.monitoring.svc.cluster.local:3100
```
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
※ namespace が異なる datasource を参照する場合は FQDN を設定
```
http://monitoring-backend-prometheus-db01-001.monitoring.svc.cluster.local:9090
```
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