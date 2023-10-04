.PHONY: up
up:
	docker compose build --no-cache
	docker compose up

.PHONY: build-prometheus
build-prometheus:
	gcloud builds submit --config .cloudbuild/build_prometheus.yml

.PHONY: build-blackbox-exporter
build-blackbox-exporter:
	gcloud builds submit --config .cloudbuild/build_blackbox-exporter.yml

.PHONY: deploy-prometheus-sidecars
deploy-prometheus-sidecars:
	gcloud run services describe prometheus-cluster --format export --region ${REGION} > service.yml
	gcloud run services replace service.yml

.PHONY: deploy-prometheus-main
deploy-prometheus-main:
	gcloud run deploy prometheus-cluster --region ${REGION} --image ${REGION}-docker.pkg.dev/${PROJECT_ID}/prometheus/prometheus:latest
