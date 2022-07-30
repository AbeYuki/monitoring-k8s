# Grafana + MySQL + Loki + Promtail + InfluxDB + Telegraf + Promethus + Node-exporter + Alertmager
[![CircleCI](https://dl.circleci.com/status-badge/img/gh/AbeYuki/monitoring-k8s/tree/main.svg?style=shield)](https://dl.circleci.com/status-badge/redirect/gh/AbeYuki/monitoring-k8s/tree/main)
![Argocd](https://argocd.aimhighergg.com/api/badge?name=monitoring-k8s&revision=true)

![telegraf UI](./docs/ui-telegraf-resources.png)
![telegraf UI](./docs/ui-telegraf-network.png)
![loki UI](./docs/ui-loki.png)
# setup

<br>

## はじめに
README.md ファイルがある場所へ移動  
シークレットを含んだファイル(★add, ★modify)の追加、修正を行い deploy する流れ  
cat リダイレクトでファイル作成例としているが、エディタでの作成を推奨  
```
.
├── base
│   ├── alertmanager
│   │   └── deployment-backend-manager01.yaml
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
├── docs
│   ├── datasource-influxdb.png
│   ├── datasource-loki.png
│   ├── import-dashboard1.png
│   ├── import-dashboard2.png
│   ├── import-dashboard3.png
│   ├── import-dashboard4.png
│   ├── ui-loki.png
│   ├── ui-telegraf-network.png
│   └── ui-telegraf-resources.png
├── overlay
│   ├── dev
│   │   ├── config-loki.yaml
│   │   ├── config-prometheus.yaml
│   │   ├── config-promtail.yaml
│   │   ├── kustomization.yaml
│   │   ├── namespace.yaml
│   │   ├── rules-prometheus.yaml
│   │   ├── secret
│   │   │   ├── config-alertmanager.yaml ★add
│   │   │   ├── grafana.ini ★add
│   │   │   ├── kustomization.yaml ★modify
│   │   │   ├── password.txt ★add
│   │   │   ├── telegraf.conf ★add
│   │   │   └── token.txt ★add
│   │   ├── transformer-label.yaml
│   │   └── transformer-suffixprefix.yaml
│   ├── prod
│   │   ├── config-loki.yaml
│   │   ├── config-prometheus.yaml
│   │   ├── config-promtail.yaml
│   │   ├── kustomization.yaml
│   │   ├── namespace.yaml
│   │   ├── rules-prometheus.yaml
│   │   ├── secret
│   │   │   ├── config-alertmanager.yaml ★add
│   │   │   ├── grafana.ini ★add
│   │   │   ├── kustomization.yaml ★modify
│   │   │   ├── password.txt ★add
│   │   │   ├── telegraf.conf ★add
│   │   │   └── token.txt ★add
│   │   ├── transformer-label.yaml
│   │   └── transformer-suffixprefix.yaml
│   └── testing
│       ├── config-loki.yaml
│       ├── config-prometheus.yaml
│       ├── config-promtail.yaml
│       ├── kustomization.yaml
│       ├── namespace.yaml
│       ├── rules-prometheus.yaml
│       ├── secret
│       │   ├── config-alertmanager.yaml ★add
│       │   ├── grafana.ini ★add
│       │   ├── kustomization.yaml ★modify
│       │   ├── password.txt ★add
│       │   ├── telegraf.conf ★add
│       │   └── token.txt ★add
│       ├── transformer-label.yaml
│       └── transformer-suffixprefix.yaml
└── README.md
```

<br>

## testing 環境の kustomize へ移動
```
cd overlay/testing/
```


## kustomize.yaml setup( secret フォルダで管理)
secretGenerator で作成するパスワード、トークンファイル作成
```bash
echo -n 'password' > secret/password.txt
```
```bash
echo -n 'token' > secret/token.txt
```

<br>

## grafana setup( secret フォルダで管理)
kustomization.yaml で指定したパスワードに修正し、grafana/grafana.ini ファイル作成
```
[database]  
  password = 修正
  mysql://grafana:修正@testing-monitoring-backend-grafana-db01-001:3306/grafana

[session]  
  provider_config = `grafana:修正@tcp(testing-monitoring-backend-grafana-db01-001:3306)/grafana` 
```

password に "#" または ";" が含まれている場合は三重引用符にする必要がある  
例)  
```
[database]
  password = #password; -> 誤
[database]
  password = """#password;""" -> 正
```

※環境ごとの service 名については、以下の命名規則で修正  
■prod
```
monitoring-backend-grafana-db01-001
```
■dev
```
dev-monitoring-backend-grafana-db01-001
```
■testing
```
testing-monitoring-backend-grafana-db01-001
```

```conf
cat <<'EOF'> secret/grafana.ini
[server]
  protocol = http
  http_port = 3000
[database]
  type = mysql
  host = testing-monitoring-backend-grafana-db01-001:3306
  name = grafana
  user = grafana
  password = password
  ssl_mode = disable
  url = mysql://grafana:password@testing-monitoring-backend-grafana-db01-001:3306/grafana
[session]
  provider_config = `grafana:password@tcp(testing-monitoring-backend-grafana-db01-001:3306)/grafana` 
  provider = mysql
[analytics]
  reporting_enabled = false
  check_for_updates = true
[log]
  mode = console
  level = info
[paths]
  data         = /var/lib/grafana/data
  logs         = /var/log/grafana
  plugins      = /var/lib/grafana/plugins
  provisioning = /etc/grafana/provisioning
[unified_alerting]
  enabled = true
[alerting]
[annotations.api]
[annotations.dashboard]
[annotations]
[auth.anonymous]
[auth.azuread]
[auth.basic]
[auth.generic_oauth]
[auth.github]
[auth.gitlab]
[auth.google]
[auth.grafana_com]
[auth.jwt]
[auth.ldap]
[auth.okta]
[auth.proxy]
[auth]
[aws]
[azure]
[dashboards]
[dataproxy]
[datasources]
[date_formats]
[emails]
[enterprise]
[explore]
[expressions]
[external_image_storage.azure_blob]
[external_image_storage.gcs]
[external_image_storage.local]
[external_image_storage.s3]
[external_image_storage.webdav]
[external_image_storage]
[feature_toggles]
[geomap]
[grafana_com]
[live]
[log.console]
[log.file]
[log.frontend]
[log.syslog]
[metrics.environment_info]
[metrics.graphite]
[metrics]
[panels]
[plugin.grafana-image-renderer]
[plugins]
[quota]
[remote_cache]
[rendering]
[security]
[smtp]
[snapshots]
[tracing.jaeger]
[unified_alerting]
[users]
EOF
```

<br>

## telegraf setup( secret フォルダで管理)
kustomization.yaml で指定したトークンに修正、disk 等の監視対象の調整を行い telegraf/telegraf.conf ファイル作成  
```conf
[[outputs.influxdb_v2]]  
  token = "修正"  
[[inputs.disk]]  
  fstype = [ "ext4", "xfs" ]  
  path = [ "/", "/backup", "/var/lib/longhorn" ]  
```

※環境ごとの service 名については、以下の命名規則で修正  
■prod
```
monitoring-backend-influxdb-db01-001
```
■dev
```
dev-monitoring-backend-influxdb-db01-001
```
■testing
```
testing-monitoring-backend-influxdb-db01-001
```

```conf
cat <<'EOF'> secret/telegraf.conf
[agent]
  interval = "60s"
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = "0s"
  flush_interval = "10s"
  flush_jitter = "0s"
  precision = ""
  hostname = "$HOSTNAME"
  omit_hostname = false
[[outputs.influxdb_v2]]
  urls = ["http://testing-monitoring-backend-influxdb-db01-001:8086"]
  token = "token"
  organization = "monitoring"
  bucket = "monitoring"
  timeout = "5s"    
[[inputs.cpu]]
  percpu = true
  totalcpu = true
  fielddrop = ["time_*"]
[[inputs.system]]
[[inputs.disk]]
  ignore_fs = ["tmpfs", "devtmpfs", "devfs", "iso9660", "overlay", "aufs", "squashfs"]
  mount_points = ["/", "/backup", "/var/lib/longhorn"]
[inputs.disk.tagpass]
  fstype = [ "ext4", "xfs" ]
  path = [ "/", "/backup", "/var/lib/longhorn" ]
[[inputs.diskio]]
  devices = ["sd*"]
[[inputs.kernel]]
[[inputs.mem]]
[[inputs.processes]]
[[inputs.swap]]
[[inputs.system]]
[[inputs.net]]
[[inputs.netstat]]
[[inputs.interrupts]]
[[inputs.linux_sysctl_fs]]
[[inputs.docker]]
  endpoint = "unix:///var/run/docker.sock"
[[inputs.kubernetes]]
  url = "https://$HOSTIP:10250"
  bearer_token = "/run/secrets/kubernetes.io/serviceaccount/token"
  insecure_skip_verify = true
EOF
```

<br>  

## alertmanager setup( secret フォルダで管理)
slack_api_url と slack_configs の channel を修正し config を作成
```
cat <<'EOF'> secret/config.yaml
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

## prometheus rule setup
環境に合わせて alert rule の config設定  
デフォルトの設定ファイルではテストアラート設定済み
```
vi rules-prometheus.yaml
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

# deploy 
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

# Grafana datasource setting
## Influxdb setting
- Query Language
  - Flux
- url
  - http://testing-monitoring-backend-influxdb-db01-001:8086
- Access
  - Server(default)
- InfluxDB Details
  - Organization
    - monitoring
  - Token
    - token
  - Default Bucket
    - monitoring

![datasource-influxdb](./docs/datasource-influxdb.png)

<br>

## Loki setting
※ namespace が異なる datasource を参照する場合は FQDN を設定
```
http://monitoring-frontend-loki-app01-001.monitoring.svc.cluster.local:3100
```
- HTTP
  - URL
    - http://testing-monitoring-frontend-loki-app01-001:3100

![datasource-influxdb](./docs/datasource-loki.png)


## prometheus setting
※ namespace が異なる datasource を参照する場合は FQDN を設定
```
http://monitoring-backend-prometheus-db01-001.monitoring.svc.cluster.local:9090
```
- HTTP
  - URL
    - http://testing-monitoring-backend-prometheus-db01-001:9090

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