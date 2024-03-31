VERSION = 2.0.0

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
	- deployment modes
		- read,ruler
		- write
		- backend
	- promtail
- influxdb
	- telegraf
- minio-loki
- minio-mimir

## 前回のreleaseとの変更点
- Loki backend storage を ファイルシステムから minio に変更
- Loki read に ruler のプロセスと ruler のコンフィグ追加
	- Grafana から Alert rules を参照できるようにするため

endef

export RELEASE_NOTES

tag:
	git tag $(VERSION)
	git push origin $(VERSION)

release:
	echo "$$RELEASE_NOTES" | gh release create $(VERSION) -t "$(VERSION)" -F -

all: tag release