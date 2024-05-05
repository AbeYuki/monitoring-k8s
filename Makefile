VERSION = 2.1.0

define RELEASE_NOTES
## 構成
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
	- simple scalable deployment modes
		- read,ruler
		- write
		- backend
	- promtail
- influxdb
	- telegraf
- minio-loki
- minio-mimir

## 前回のreleaseとの変更点
- Loki
	- version 2.9.4 から 3.0.0 にアップデート
	- ローカルストレージを1つの PVC(RWX) で各コンポーネントの共有ストレージとして利用していたが statefulSet に変更

endef

export RELEASE_NOTES

tag:
	git tag $(VERSION)
	git push origin $(VERSION)

release:
	echo "$$RELEASE_NOTES" | gh release create $(VERSION) -t "$(VERSION)" -F -

all: tag release