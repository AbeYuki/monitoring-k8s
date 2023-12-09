VERSION = 1.0.1

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
		- filesystem
	- deployment modes
		- read
		- write
		- backend
	- promtail
- influxdb
	- telegraf

## 前のreleaseとの変更点
- testing 環境の grafana.ini config 修正
- grafana の datasource.yaml 追加

endef

export RELEASE_NOTES

tag:
	git tag $(VERSION)
	git push origin $(VERSION)

release:
	echo "$$RELEASE_NOTES" | gh release create $(VERSION) -t "$(VERSION)" -F -

all: tag release