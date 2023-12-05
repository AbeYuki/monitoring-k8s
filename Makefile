VERSION = 1.0.0

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
endef

export RELEASE_NOTES

tag:
	git tag $(VERSION)
	git push origin $(VERSION)

release:
	echo "$$RELEASE_NOTES" | gh release create $(VERSION) -t "$(VERSION)" -F -

all: tag release