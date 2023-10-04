# Deployment Guide

## 1. Build Container Images

### 1.1 Ingress Container Image

Build prometheus.

```bash
gcloud builds submit --config .cloudbuild/build_prometheus.yml
```
Or use Makefile command:

```bash
make build-prometheus
```

### 1.2 Sidecars (exporters, alertmanger)

Build sidecars (exporters, alertmanagers).

```bash
gcloud builds submit --config .cloudbuild/build_blackbox-exporter.yml
```
Or use Makefile command:

```bash
make build-blackbox-exporter
```


## 2. Deploy to Cloud Run

### 2.1 Ingress Container

Deploy prometheus.

```bash
gcloud run deploy prometheus-cluster --region ${REGION} --image ${REGION}-docker.pkg.dev/${PROJECT_ID}/prometheus/prometheus:latest
```
Or use Makefile command:

```bash
make deploy-prometheus-main
```

### 2.2 Sidecars

To deploy sidecars, you should edit YAML from Cloud Run.
Official documentation is [here](https://cloud.google.com/run/docs/deploying?hl=ja#sidecars).


Firstly, retrieve YAML from Cloud Run.

```bash
gcloud run services describe prometheus-cluster --format export --region ${REGION} > service.yml
```
Then, you edit service.yml to add sidecars like this. Here we add blackbox-exporter as a sidecar.

```yaml
    spec:
      containerConcurrency: 80
      containers:
      # ingress container (don't edit here)
      - image: asia-northeast1-docker.pkg.dev/${PROJECT_ID}/prometheus/prometheus:latest
        ports:
        - containerPort: 9090
          name: http1
        resources:
          limits:
            cpu: 1000m
            memory: 512Mi
        startupProbe:
          failureThreshold: 1
          periodSeconds: 240
          tcpSocket:
            port: 9090
          timeoutSeconds: 240
    # sidecar part (add sidecars here)
      - image: asia-northeast1-docker.pkg.dev/${PROJECT_ID}/prometheus/blackbox-exporter:latest
        name: blackbox-exporter
        resources:
          limits:
            cpu: 1000m
            memory: 256Mi
```

Finally, replace service.yml in Cloud Run. This is equivalent to deploying sidecars.

```bash
gcloud run services replace service.yml
```
